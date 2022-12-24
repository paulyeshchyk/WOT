//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    private enum JSONAdapterError: Error {
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

        json.keys.forEach { key in

            dispatchGroup.enter()
            //
            let extraction = linker.performJSONExtraction(from: json, byKey: key, forClazz: modelClazz, request: fromRequest)

            self.findOrCreateObject(json: extraction.json, requestPredicate: extraction.requestPredicate) {[weak self] fetchResult, error in
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
    private func findOrCreateObject(json: JSON, requestPredicate: RequestPredicate, callback externalCallback: @escaping FetchResultCompletion) {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            fatalError("thread is not main")
        }

        let localCallback: FetchResultCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        context.dataStore?.fetchLocal(byModelClass: modelClazz, requestPredicate: requestPredicate[.primary]?.predicate, completion: { fetchResult, error in

            if let error = error {
                localCallback(fetchResult, error)
                return
            }

            let jsonStartParsingDate = Date()
            self.context.logInspector?.logEvent(EventJSONStart(requestPredicate), sender: self)
            self.context.mappingCoordinator?.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: nil, inContext: self.context) { fetchResult, error in
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.context.logInspector?.logEvent(EventJSONEnded("\(String(describing: requestPredicate))", initiatedIn: jsonStartParsingDate), sender: self)
                localCallback(fetchResult, nil)
            }
        })
    }
}

public struct JSONExtraction {
    public let requestPredicate: RequestPredicate
    public let json: JSON
}

extension JSONAdapterLinkerProtocol {
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, request fromRequest: RequestProtocol) -> JSONExtraction {
        guard let json = from[key] as? JSON else {
            fatalError("invalid json for key")
        }

        let extractedJSON = onJSONExtraction(json: json)

        let ident: Any
        if let primaryKeyPath = modelClazz.primaryKeyPath(forType: linkerPrimaryKeyType) {
            ident = extractedJSON[primaryKeyPath] ?? key
        } else {
            ident = key
        }

        let parents = fromRequest.paradigm?.requestPredicate()?.parentObjectIDList
        let requestPredicate = RequestPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClazz.primaryKey(for: ident as AnyObject, andType: linkerPrimaryKeyType)

        return JSONExtraction(requestPredicate: requestPredicate, json: extractedJSON)
    }
}
