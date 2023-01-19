//
//  WOTWEBRequestLogout.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - LogoutHttpRequest

public class LogoutHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "wot/auth/logout/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
}

// MARK: - LogoutHttpRequest + RequestModelServiceProtocol

extension LogoutHttpRequest: RequestModelServiceProtocol {
    public class func responseDataDecoderClass() -> ResponseDataDecoderProtocol.Type {
        WGApiJSONDataDecoder.self
    }

    public static func modelClass() -> ModelClassType? {
        return nil
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.logout.rawValue
    }
}
