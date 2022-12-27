//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    private enum JSONAdapterError: Error, CustomStringConvertible {
        case notMainThread
        case requestManagerIsNil
        case fetchResultIsNotPresented
        var description: String {
            switch self {
            case .notMainThread: return "\(type(of: self)): Not main thread"
            case .requestManagerIsNil: return "\(type(of: self)): request manager is nil"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }

    // MARK: DataAdapterProtocol -

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    // MARK: JSONAdapterProtocol -

    public var linker: AdapterLinkerProtocol

    // MARK: Private -

    private let appContext: JSONAdapterProtocol.Context
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol
    private func didFoundObject(_ fetchResult: FetchResultProtocol, error: Error?) {}

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public required init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: JSONAdapterProtocol.Context, adapterLinker: AdapterLinkerProtocol) {

        self.modelClazz = modelClass
        self.request = request
        self.linker = adapterLinker
        self.appContext = context

        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        appContext.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    // MARK: - JSONAdapterProtocol

    private func didFinishDecoding(_ json: JSON?, fromRequest: RequestProtocol, error: Error?, completion: ResponseAdapterProtocol.OnComplete?) {
        guard error == nil, let json = json else {
            self.appContext.logInspector?.logEvent(EventError(error, details: fromRequest), sender: self)
            completion?(fromRequest, error)
            return
        }

        let jsonStartParsingDate = Date()
        appContext.logInspector?.logEvent(EventJSONStart(fromRequest), sender: self)

        let dispatchGroup = DispatchGroup()

        for key in json.keys {

            dispatchGroup.enter()
            //
            do {
                let contextPredicate = fromRequest.contextPredicate
                let extraction = try linker.performJSONExtraction(from: json, byKey: key, forClazz: modelClazz, contextPredicate: contextPredicate)

                try self.findOrCreateObject(json: extraction.json, predicate: extraction.requestPredicate) { [weak self] fetchResult, error in
                    guard let self = self else {
                        dispatchGroup.leave()
                        return
                    }
                    guard let fetchResult = fetchResult else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    if let error = error {
                        self.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                        dispatchGroup.leave()
                        return
                    }

                    self.linker.process(fetchResult: fetchResult, dataStore: self.appContext.dataStore) { _, error in
                        if let error = error {
                            self.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                        }
                        dispatchGroup.leave()
                    }
                }
            } catch {
                dispatchGroup.leave()
                appContext.logInspector?.logEvent(EventError(error, details: nil))
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.appContext.logInspector?.logEvent(EventJSONEnded(fromRequest, initiatedIn: jsonStartParsingDate), sender: self)
            completion?(fromRequest, error)
        }
    }
}

extension JSONAdapter {
    
    public func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?) where T: RESTAPIResponseProtocol {
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
    private func findOrCreateObject(json: JSONCollectable?, predicate: ContextPredicate, callback externalCallback: @escaping FetchResultCompletion) throws {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            throw JSONAdapterError.notMainThread
        }
        
        let localCallback: FetchResultCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        appContext.dataStore?.fetchLocal(byModelClass: modelClazz, requestPredicate: predicate[.primary]?.predicate, completion: { fetchResult, error in

            if let error = error {
                localCallback(fetchResult, error)
                return
            }
            guard let fetchResult = fetchResult else {
                localCallback(nil, JSONAdapterError.fetchResultIsNotPresented)
                return
            }

            let jsonStartParsingDate = Date()
            self.appContext.logInspector?.logEvent(EventJSONStart(predicate), sender: self)
            self.appContext.mappingCoordinator?.mapping(json: json, fetchResult: fetchResult, predicate: predicate, linker: nil, inContext: self.appContext) { fetchResult, error in
                if let error = error {
                    self.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.appContext.logInspector?.logEvent(EventJSONEnded("\(String(describing: predicate))", initiatedIn: jsonStartParsingDate), sender: self)
                localCallback(fetchResult, nil)
            }
        })
    }
}

public struct JSONExtraction {
    public let requestPredicate: ContextPredicate
    public let json: JSONCollectable?

    enum JSONAdapterLinkerExtractionErrors: Error, CustomStringConvertible {
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

extension AdapterLinkerProtocol {
    
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicate?) throws -> JSONExtraction {
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

        #warning("2b refactored")
        let parents = contextPredicate?.parentObjectIDList

        let requestPredicate = ContextPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClazz.primaryKey(forType: linkerPrimaryKeyType, andObject: ident as AnyObject)

        let jsonCollection = try JSONCollection(element: extractedJSON)
        return JSONExtraction(requestPredicate: requestPredicate, json: jsonCollection)
    }
}
