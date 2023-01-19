//
//  JSONDataDecoder.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - JSONDataDecoder

open class JSONDataDecoder: JSONDataDecoderProtocol, CustomStringConvertible {

    public var completion: ResponseDataDecoderProtocol.OnComplete?

    public var MD5: String { uuid.MD5 }

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    // MARK: DataAdapterProtocol -

    private let uuid = UUID()
    private let appContext: Context

    public weak var request: RequestProtocol?

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

    public func decode(data: Data?, fromRequest request: RequestProtocol) {
        guard let data = data else {
            completion?(request, nil, Errors.dataIsNil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decodedObject(jsonDecoder: decoder, from: data)
            completion?(request, result, nil)
        } catch {
            let exception = Errors.responseError(request, error)
            completion?(request, nil, exception)
        }
    }
}

// MARK: - %t + JSONDataDecoder.Errors

extension JSONDataDecoder {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case dataIsNil
        case responseError(RequestProtocol, Error)

        public var description: String {
            switch self {
            case .dataIsNil: return "\(type(of: self)): Data is nil"
            case .responseError(let request, let error): return "[\(String(describing: request))]: \(String(describing: error))"
            }
        }
    }
}
