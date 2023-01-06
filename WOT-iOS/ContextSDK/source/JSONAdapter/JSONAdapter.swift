//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - JSONAdapter

open class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    public required init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, managedObjectLinker: ManagedObjectLinkerProtocol, jsonExtractor: ManagedObjectExtractable, appContext: JSONAdapterProtocol.Context) {
        self.modelClass = modelClass
        self.request = request
        self.managedObjectLinker = managedObjectLinker
        self.jsonExtractor = jsonExtractor
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    open var responseClass: AnyClass {
        fatalError("has not been implemented")
    }

    open func decodedObject(jsonDecoder _: JSONDecoder, from _: Data) throws -> JSON? {
        fatalError("has not been implemented")
    }

    public var MD5: String { uuid.MD5 }

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public func decode(data: Data?, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?) {
        guard let data = data else {
            didFinish(request: request, data: nil, error: JSONAdapterError.dataIsNil, completion: completion)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decodedObject(jsonDecoder: decoder, from: data)
            didFinish(request: request, data: result, error: nil, completion: completion)
        } catch {
            let exception = JSONAdapterError.responseError(request, error)
            didFinish(request: request, data: nil, error: exception, completion: completion)
        }
    }

    // MARK: DataAdapterProtocol -

    private let uuid = UUID()
    private var managedObjectLinker: ManagedObjectLinkerProtocol
    private var jsonExtractor: ManagedObjectExtractable

    private let appContext: JSONAdapterProtocol.Context
    private let modelClass: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol

    private func didFoundObject(_: FetchResultProtocol, error _: Error?) {}
}

public extension JSONAdapter {
    func didFinish(request: RequestProtocol, data: JSON?, error: Error?, completion: ResponseAdapterProtocol.OnComplete?) {
        guard error == nil, let json = data else {
            appContext.logInspector?.log(.error(error!), sender: self)
            completion?(request, error)
            return
        }

        let jsonStartParsingDate = Date()

        let dispatchGroup = DispatchGroup()

        for key in json.keys {
            dispatchGroup.enter()
            //
            do {
                let contextPredicate = request.contextPredicate

                #warning("refactoring initial step")
                let extraction = try jsonExtractor.extract(json: json, key: key, forClazz: modelClass, contextPredicate: contextPredicate)

                try findOrCreateObject(json: extraction.json, predicate: extraction.requestPredicate) { [weak self] fetchResult, error in
                    guard let self = self, let fetchResult = fetchResult else {
                        dispatchGroup.leave()
                        completion?(request, error)
                        return
                    }

                    if let error = error {
                        self.appContext.logInspector?.log(.error(error), sender: self)
                        dispatchGroup.leave()
                        completion?(request, error)
                        return
                    }

                    self.managedObjectLinker.process(fetchResult: fetchResult, appContext: self.appContext) { _, error in
                        if let error = error {
                            self.appContext.logInspector?.log(.error(error), sender: self)
                        }
                        completion?(request, error)
                        dispatchGroup.leave()
                    }
                }
            } catch {
                dispatchGroup.leave()
                completion?(request, error)
                appContext.logInspector?.log(.error(error), sender: self)
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion?(request, error)
        }
    }

    private func findOrCreateObject(json: JSONCollectionProtocol?, predicate: ContextPredicateProtocol, callback externalCallback: @escaping FetchResultCompletion) throws {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            throw JSONAdapterError.notMainThread
        }

        let localCallback: FetchResultCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        let nspredicate = predicate[.primary]?.predicate
        appContext.dataStore?.fetch(modelClass: modelClass, nspredicate: nspredicate, completion: { [weak self] fetchResult, error in
            guard let self = self else {
                localCallback(fetchResult, JSONAdapterError.adapterIsNil)
                return
            }
            if let error = error {
                localCallback(fetchResult, error)
                return
            }
            guard let fetchResult = fetchResult else {
                localCallback(nil, JSONAdapterError.fetchResultIsNotPresented)
                return
            }

            let jsonStartParsingDate = Date()
            self.appContext.mappingCoordinator?.decode(using: json, fetchResult: fetchResult, predicate: predicate, managedObjectCreator: nil, managedObjectExtractor: nil, inContext: self.appContext) { fetchResult, error in
                if let error = error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
                localCallback(fetchResult, error)
            }
        })
    }
}

// MARK: - JSONAdapterError

private enum JSONAdapterError: Error, CustomStringConvertible {
    case dataIsNil
    case adapterIsNil
    case notMainThread
    case fetchResultIsNotPresented
    case jsonByKeyWasNotFound(JSON, AnyHashable)
    case notSupportedType(AnyClass)
    case responseError(RequestProtocol, Error)

    public var description: String {
        switch self {
        case .adapterIsNil: return "\(type(of: self)): Adapter is nil"
        case .dataIsNil: return "\(type(of: self)): Data is nil"
        case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adopted"
        case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
        case .notMainThread: return "\(type(of: self)): Not main thread"
        case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
        case .responseError(let request, let error): return "\(String(describing: error)); \n \(String(describing: request))"
        }
    }
}
