//
//  JMetadata.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    @objc
    public class RequestMetadata: NSObject, Codable {
        private var count: Int
        private var limit: Int
        private var page_total: Int
        private var total: Int

        private enum CodingKeys: String, CodingKey {
            case count
            case limit
            case page_total
            case total
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            count = try container.decode(.count)
            limit = try container.decode(.limit)
            page_total = try container.decode(.page_total)
            total = try container.decode(.total)
        }
    }

}
