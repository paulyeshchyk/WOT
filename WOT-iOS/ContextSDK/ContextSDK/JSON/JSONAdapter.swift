//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    private enum JSONAdapterError: Error, CustomStringConvertible {
        case requestManagerIsNil
        var description: String {
            switch self {
            case .requestManagerIsNil: return "\(type(of: self)):  request manager is nil"
            }
        }
    }

    // MARK: DataAdapterProtocol -

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    // MARK: JSONAdapterProtocol -

    public var linker: JSONAdapterLinkerProtocol

    // MARK: Private -

    private let context: JSONAdapterProtocol.Context
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol
    private func didFoundObject(_ fetchResult: FetchResultProtocol, error: Error?) {}

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public required init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: JSONAdapterProtocol.Context, jsonAdapterLinker: JSONAdapterLinkerProtocol) {
        self.modelClazz = clazz
        self.request = request
        self.linker = jsonAdapterLinker
        self.context = context

        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        context.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    // MARK: - JSONAdapterProtocol

    private func didFinishDecoding(_ json: JSON?, fromRequest: RequestProtocol, error: Error?, completion: DataAdapterProtocol.OnComplete?) {
        guard error == nil, let json = json else {
            self.context.logInspector?.logEvent(EventError(error, details: fromRequest), sender: self)
            completion?(fromRequest, error)
            return
        }

        let jsonStartParsingDate = Date()
        context.logInspector?.logEvent(EventJSONStart(fromRequest), sender: self)

        let dispatchGroup = DispatchGroup()

        for key in json.keys {

            dispatchGroup.enter()
            //
            do {

                let extraction = try linker.performJSONExtraction(from: json, byKey: key, forClazz: modelClazz, request: fromRequest)

                self.findOrCreateObject(json: extraction.json, predicate: extraction.requestPredicate) {[weak self] fetchResult, error in
                    guard let self = self else {
                        dispatchGroup.leave()
                        return
                    }
                    if let error = error {
                        self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                        dispatchGroup.leave()
                        return
                    }

                    self.linker.process(fetchResult: fetchResult, dataStore: self.context.dataStore) { _, error in
                        if let error = error {
                            self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                        }
                        dispatchGroup.leave()
                    }
                }
            } catch {
                dispatchGroup.leave()
                context.logInspector?.logEvent(EventError(error, details: nil))
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.context.logInspector?.logEvent(EventJSONEnded(fromRequest, initiatedIn: jsonStartParsingDate), sender: self)
            completion?(fromRequest, error)
        }
    }
}

extension JSONAdapter {
    
    public func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: RequestProtocol, completion: DataAdapterProtocol.OnComplete?) where T: RESTAPIResponseProtocol {
        guard let data = binary else {
            didFinishDecoding(nil, fromRequest: request, error: nil, completion: completion)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            if let swiftError = result.swiftError {
                didFinishDecoding(nil, fromRequest: request, error: swiftError, completion: completion)
            } else {
                didFinishDecoding(result.data, fromRequest: request, error: nil, completion: completion)
            }
        } catch {
            didFinishDecoding(nil, fromRequest: request, error: error, completion: completion)
        }
    }
}


extension JSONAdapter {
    private func findOrCreateObject(json: JSONCollectable?, predicate: ContextPredicate, callback externalCallback: @escaping FetchResultCompletion) {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            fatalError("thread is not main")
        }
        
        let localCallback: FetchResultCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        context.dataStore?.fetchLocal(byModelClass: modelClazz, requestPredicate: predicate[.primary]?.predicate, completion: { fetchResult, error in

            if let error = error {
                localCallback(fetchResult, error)
                return
            }

            let jsonStartParsingDate = Date()
            self.context.logInspector?.logEvent(EventJSONStart(predicate), sender: self)
            self.context.mappingCoordinator?.mapping(json: json, fetchResult: fetchResult, predicate: predicate, linker: nil, inContext: self.context) { fetchResult, error in
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.context.logInspector?.logEvent(EventJSONEnded("\(String(describing: predicate))", initiatedIn: jsonStartParsingDate), sender: self)
                localCallback(fetchResult, nil)
            }
        })
    }
}

public struct JSONExtraction {
    public let requestPredicate: ContextPredicate
    public let json: JSONCollectable?

    public enum JSONAdapterLinkerExtractionErrors: Error, CustomStringConvertible {
        case invalidJSONForKey(AnyHashable)
        case jsonWasNotExtracted(JSON)
        public var description: String {
            switch self {
            case .invalidJSONForKey(let key): return "[\(type(of: self))]: Invalid json for key: \(key)"
            case .jsonWasNotExtracted(let json): return "[\(type(of: self))]: json was not extracted from: \(json)"
            }
        }
    }
}

extension JSONAdapterLinkerProtocol {
    
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, request fromRequest: RequestProtocol) throws -> JSONExtraction {
        guard let json = from[key] as? JSON else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.invalidJSONForKey(key)
        }

        guard let extractedJSON = onJSONExtraction(json: json) else {
            throw JSONExtraction.JSONAdapterLinkerExtractionErrors.jsonWasNotExtracted(json)
        }

        let ident: Any
        if let primaryKeyPath = modelClazz.primaryKeyPath(forType: linkerPrimaryKeyType) {
            ident = extractedJSON[primaryKeyPath] ?? key
        } else {
            ident = key
        }

        let parents = fromRequest.paradigm?.predicate()?.parentObjectIDList
        let requestPredicate = ContextPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClazz.primaryKey(for: ident as AnyObject, andType: linkerPrimaryKeyType)

        let jsonCollection = try JSONCollection(element: extractedJSON)
        return JSONExtraction(requestPredicate: requestPredicate, json: jsonCollection)
    }
}
