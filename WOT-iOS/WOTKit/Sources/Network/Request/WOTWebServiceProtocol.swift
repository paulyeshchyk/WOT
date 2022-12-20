//
//  WOTWebServiceProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK


@objc
public enum HTTPMethods: Int {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case CONNECT
    case OPTIONS
    case TRACE
    case PATCH
    var stringRepresentation: String {
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
public protocol WOTWebServiceProtocol {
    var method: HTTPMethods { get }
    var path: String { get }
}

@objc
public protocol WOTModelServiceProtocol: AnyObject {
    @objc
    static func modelClass() -> PrimaryKeypathProtocol.Type?

    @objc
    func instanceModelClass() -> AnyClass?
}
