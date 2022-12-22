//
//  HttpServiceProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public enum HTTPMethod: Int {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH

    public var stringRepresentation: String {
        switch self {
        case .GET: return "GET"
        case .HEAD: return "HEAD"
        case .POST: return "POST"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        case .CONNECT: return "CONNECT"
        case .OPTIONS: return "OPTIONS"
        case .TRACE: return "TRACE"
        case .PATCH: return "PATCH"
        }
    }
}

@objc
public protocol HttpServiceProtocol {
    var httpMethod: ContextSDK.HTTPMethod { get }
    var path: String { get }
}

@objc
public protocol WOTModelServiceProtocol: AnyObject {
    @objc
    static func modelClass() -> PrimaryKeypathProtocol.Type?

    @objc
    func instanceModelClass() -> AnyClass?
}
