//
//  WOTWebResponseMeta.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public struct WOTWebResponseMeta {
    var count: Int
    var page_total: Int
    var total: Int
    var limit: Int
    var page: Int?
    init(count: Int, page_total: Int, total: Int, limit: Int, page: Int?) {
        self.count = count
        self.page_total = page_total
        self.total = total
        self.limit = limit
        self.page = page
    }
}

extension WOTWebResponseMeta: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case count
        case page_total
        case total
        case limit
        case page
    }

    public typealias Fields = FieldKeys

    mutating public func mapping(fromJSON jSON: JSON) {
        count = jSON["count"] as? Int ?? 0
        page_total = jSON["page_total"] as? Int ?? 0
        total = jSON["total"] as? Int ?? 0
        limit = jSON["limit"] as? Int ?? 0
        page = jSON["page"] as? Int
    }
}
