//
//  WOTWebResponse.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum WOTWebResponseStatus: String {
    public typealias RawValue = String

    case ok
    case error
    case unknown

    init?(value: String) {
        if value.lowercased().compare(WOTWebResponseStatus.ok.rawValue) == .orderedSame {
            self = .ok
        } else if value.lowercased().compare(WOTWebResponseStatus.error.rawValue) == .orderedSame {
            self = .error
        } else {
            self = .unknown
        }
    }
}

public class WGResponseObject: NSObject {
    public var status: WOTWebResponseStatus = .unknown
    public var meta: WOTWebResponseMeta?
    public var data: JSON?
    public var error: JSON?
}

extension WGResponseObject: JSONMapperProtocol {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
    }

    public func mapping(fromJSON jSON: JSON) {
        self.status = WOTWebResponseStatus(rawValue: (jSON["status"] as? String) ?? "") ?? .unknown
        self.data = jSON["data"] as? JSON
        self.error = jSON["error"] as? JSON

        let meta = WOTWebResponseMeta(count: 0, page_total: 0, total: 0, limit: 0, page: nil)
        if let metaJSON = jSON["meta"] as? JSON {
            meta.mapping(fromJSON: metaJSON)
        }
        self.meta = meta
    }

    public func mapping(fromArray array: [Any]) {}
}
