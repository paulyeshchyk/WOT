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
            completion?(request, error ?? JSONAdapterError.jsonIsNil)
            return
        }

        let dispatchGroup = DispatchGroup()

        for key in json.keys {
            dispatchGroup.enter()
            //
            do {
                let contextPredicate = request.contextPredicate
                let extraction = try jsonExtractor.extract(json: json, key: key, forClazz: modelClass, contextPredicate: contextPredicate)

                let syndicate = Syndicate(appContext: appContext)
                syndicate.modelClass = modelClass
                syndicate.jsonExtraction = extraction
                syndicate.managedStoreLinker = managedObjectLinker
                syndicate.completion = { _, error in
                    if let error = error {
                        completion?(request, error)
                    }
                    dispatchGroup.leave()
                }
                syndicate.run()

            } catch {
                completion?(request, error)
                dispatchGroup.leave()
                appContext.logInspector?.log(.error(error), sender: self)
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion?(request, nil)
        }
    }
}

// MARK: - JSONAdapterError

private enum JSONAdapterError: Error, CustomStringConvertible {
    case jsonIsNil
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
        case .jsonIsNil: return "\(type(of: self)): JSON is nil"
        case .dataIsNil: return "\(type(of: self)): Data is nil"
        case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adapted"
        case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
        case .notMainThread: return "\(type(of: self)): Not main thread"
        case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
        case .responseError(let request, let error): return "[\(String(describing: request))]: \(String(describing: error))"
        }
    }
}
