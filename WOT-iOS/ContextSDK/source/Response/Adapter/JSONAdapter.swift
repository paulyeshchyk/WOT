//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - JSONAdapter

open class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    open var responseClass: AnyClass {
        fatalError("has not been implemented")
    }

    public var completion: ResponseAdapterProtocol.OnComplete?

    public var MD5: String { uuid.MD5 }

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    // MARK: DataAdapterProtocol -

    private let uuid = UUID()
    private let appContext: Context

    public var modelClass: ModelClassType?
    public var socket: JointSocketProtocol?
    public weak var request: RequestProtocol?
    public var extractorType: ManagedObjectExtractable.Type?

    // MARK: Lifecycle

    public required init(appContext: Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    // MARK: Open

    open func decodedObject(jsonDecoder _: JSONDecoder, from _: Data) throws -> JSON? {
        fatalError("has not been implemented")
    }

    // MARK: Public

    public func decode(data: Data?) {
        guard let data = data else {
            didFinish(request: request, data: nil, error: Errors.dataIsNil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decodedObject(jsonDecoder: decoder, from: data)
            didFinish(request: request, data: result, error: nil)
        } catch {
            let exception = Errors.responseError(request, error)
            didFinish(request: request, data: nil, error: exception)
        }
    }

    // MARK: Private

    private func didFoundObject(_: FetchResultProtocol, error _: Error?) {}
}

public extension JSONAdapter {
    //
    func didFinish(request: RequestProtocol?, data: JSON?, error: Error?) {
        guard error == nil, let json = data else {
            completion?(request, error ?? Errors.jsonIsNil)
            return
        }
        guard let modelClass = modelClass else {
            completion?(request, Errors.modelClassIsNotDefined)
            return
        }
        guard let ExtractorType = extractorType else {
            completion?(request, Errors.extractorNotFound(request))
            return
        }
        let extractor = ExtractorType.init()
        let maps = extractor.getJSONMaps(json: json, modelClass: modelClass, jsonRefs: request?.contextPredicate?.jsonRefs)

        let uow = UOWDecodeAndLinkMaps(appContext: appContext)
        uow.maps = maps
        uow.modelClass = modelClass
        uow.socket = socket
        uow.decodingDepthLevel = request?.decodingDepthLevel
        appContext.uowManager.run(unit: uow) { result in
            self.completion?(request, result.error)
        }
    }
}

// MARK: - %t + JSONAdapter.Errors

extension JSONAdapter {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case jsonIsNil
        case dataIsNil
        case modelClassIsNotDefined
        case notMainThread
        case fetchResultIsNotPresented
        case jsonByKeyWasNotFound(JSON, AnyHashable)
        case notSupportedType(AnyClass)
        case responseError(RequestProtocol?, Error)
        case extractorNotFound(RequestProtocol?)

        public var description: String {
            switch self {
            case .jsonIsNil: return "\(type(of: self)): JSON is nil"
            case .dataIsNil: return "\(type(of: self)): Data is nil"
            case .modelClassIsNotDefined: return "\(type(of: self)): ModelClass is not defined"
            case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adapted"
            case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
            case .notMainThread: return "\(type(of: self)): Not main thread"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            case .responseError(let request, let error): return "[\(String(describing: request, orValue: "NULL"))]: \(String(describing: error))"
            case .extractorNotFound(let request): return "\(type(of: self)): Extractor not found for request: \(String(describing: request, orValue: "NULL"))"
            }
        }
    }
}
