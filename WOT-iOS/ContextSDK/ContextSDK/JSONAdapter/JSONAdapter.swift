//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

open class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {
    enum JSONAdapterError: Error, CustomStringConvertible {
        case notMainThread
        case fetchResultIsNotPresented
        var description: String {
            switch self {
            case .notMainThread: return "\(type(of: self)): Not main thread"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            }
        }
    }

    // MARK: DataAdapterProtocol -

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    // MARK: Private -

    private var managedObjectCreator: ManagedObjectCreatorProtocol

    private let appContext: JSONAdapterProtocol.Context
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol
    private func didFoundObject(_ fetchResult: FetchResultProtocol, error: Error?) {}

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    required public init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: JSONAdapterProtocol.Context, managedObjectCreator: ManagedObjectCreatorProtocol) {
        self.modelClazz = modelClass
        self.request = request
        self.managedObjectCreator = managedObjectCreator
        self.appContext = context
        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        appContext.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    open func decodeData(_ data: Data?, forType: AnyClass, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?) {
        fatalError("should be overriden")
    }

    open func performJSONExtraction(from json: JSON, byKey key: AnyHashable)  throws -> JSON {
        fatalError("should be overriden")
    }
}

extension JSONAdapter {
    public func didFinish(with: Any?, fromRequest: RequestProtocol, error: Error?, completion: ResponseAdapterProtocol.OnComplete?) {
        guard error == nil, let json = with as? JSON else {
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
                _ = try performJSONExtraction(from: json, byKey: key)
                let extraction = try managedObjectCreator.performJSONExtraction(from: json, byKey: key, forClazz: modelClazz, contextPredicate: contextPredicate)

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

                    self.managedObjectCreator.process(fetchResult: fetchResult, dataStore: self.appContext.dataStore) { _, error in
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
            self.appContext.mappingCoordinator?.mapping(json: json, fetchResult: fetchResult, predicate: predicate, managedObjectCreator: nil, inContext: self.appContext) { fetchResult, error in
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

extension ManagedObjectCreatorProtocol {
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
