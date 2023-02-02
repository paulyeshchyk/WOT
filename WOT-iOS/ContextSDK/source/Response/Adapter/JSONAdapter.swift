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

    public var description: String { String(describing: self) }

    // MARK: DataAdapterProtocol -

    private let uuid = UUID()
    private let appContext: Context

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
            completion?(nil, Errors.dataIsNil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let json = try decodedObject(jsonDecoder: decoder, from: data)
            completion?(json, nil)
        } catch {
            completion?(nil, error)
        }
    }

    // MARK: Private

    private func didFoundObject(_: FetchResultProtocol, error _: Error?) {}
}

// MARK: - %t + JSONAdapter.Errors

extension JSONAdapter {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case jsonIsNil
        case dataIsNil
        case modelClassIsNotDefined
        case fetchResultIsNotPresented
        case jsonByKeyWasNotFound(JSON, AnyHashable)
        case notSupportedType(AnyClass)
        case extractorNotFound(RequestProtocol?)

        public var description: String {
            switch self {
            case .jsonIsNil: return "\(type(of: self)): JSON is nil"
            case .dataIsNil: return "\(type(of: self)): Data is nil"
            case .modelClassIsNotDefined: return "\(type(of: self)): ModelClass is not defined"
            case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adapted"
            case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            case .extractorNotFound(let request): return "\(type(of: self)): Extractor not found for request: \(String(describing: request, orValue: "NULL"))"
            }
        }
    }
}
