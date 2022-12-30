//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

open class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {
    open var responseClass: AnyClass {
        fatalError("should be overriden")
    }

    // MARK: DataAdapterProtocol -

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    // MARK: Private -

    private var managedObjectCreator: ManagedObjectCreatorProtocol

    private let appContext: JSONAdapterProtocol.Context
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol
    private func didFoundObject(_: FetchResultProtocol, error _: Error?) {}

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public required init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: JSONAdapterProtocol.Context, managedObjectCreator: ManagedObjectCreatorProtocol) {
        modelClazz = modelClass
        self.request = request
        self.managedObjectCreator = managedObjectCreator
        appContext = context
        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        appContext.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    open func decode(data: Data?, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?) {
        guard let data = data else {
            didFinish(request: request, data: nil, error: JSONAdapterError.dataIsNil, completion: completion)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decodedObject(jsonDecoder: decoder, from: data)
            didFinish(request: request, data: result, error: nil, completion: completion)
        } catch {
            didFinish(request: request, data: nil, error: error, completion: completion)
        }
    }

    open func decodedObject(jsonDecoder _: JSONDecoder, from _: Data) throws -> JSON? {
        fatalError("should be overriden")
    }
}

public extension JSONAdapter {
    func didFinish(request: RequestProtocol, data: JSON?, error: Error?, completion: ResponseAdapterProtocol.OnComplete?) {
        guard error == nil, let json = data else {
            appContext.logInspector?.logEvent(EventError(error, details: request), sender: self)
            completion?(request, error)
            return
        }

        let jsonStartParsingDate = Date()
        appContext.logInspector?.logEvent(EventJSONStart(request), sender: self)

        let dispatchGroup = DispatchGroup()

        for key in json.keys {
            dispatchGroup.enter()
            //
            do {
                let contextPredicate = request.contextPredicate

                #warning("refactoring initial step")
                let extraction = try managedObjectCreator.extract(json: json, key: key, forClazz: modelClazz, contextPredicate: contextPredicate)

                try findOrCreateObject(json: extraction.json, predicate: extraction.requestPredicate) { [weak self] fetchResult, error in
                    guard let self = self, let fetchResult = fetchResult else {
                        dispatchGroup.leave()
                        return
                    }

                    if let error = error {
                        self.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                        dispatchGroup.leave()
                        return
                    }

                    self.managedObjectCreator.process(fetchResult: fetchResult, appContext: self.appContext) { _, error in
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
            self.appContext.logInspector?.logEvent(EventJSONEnded(request, initiatedIn: jsonStartParsingDate), sender: self)
            completion?(request, error)
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
            self.appContext.mappingCoordinator?.decode(using: json, fetchResult: fetchResult, predicate: predicate, managedObjectCreator: nil, inContext: self.appContext) { fetchResult, error in
                if let error = error {
                    self.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.appContext.logInspector?.logEvent(EventJSONEnded("\(String(describing: predicate))", initiatedIn: jsonStartParsingDate), sender: self)
                localCallback(fetchResult, nil)
            }
        })
    }
}

public enum JSONAdapterError: Error, CustomStringConvertible {
    case dataIsNil
    case notMainThread
    case fetchResultIsNotPresented
    case jsonByKeyWasNotFound(JSON,AnyHashable)
    case notSupportedType(AnyClass)
    public var description: String {
        switch self {
        case .dataIsNil: return "\(type(of: self)): Data is nil"
        case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adopted"
        case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
        case .notMainThread: return "\(type(of: self)): Not main thread"
        case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
        }
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

public extension ManagedObjectCreatorProtocol {
    func extract(json: JSON, key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, contextPredicate: ContextPredicate?) throws -> JSONExtraction {
        guard let json = json[key] as? JSON else {
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
