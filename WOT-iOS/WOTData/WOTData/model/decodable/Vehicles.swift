//
//  JVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/29/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    public class Vehicles: Codable {

        var status: String?
        var meta: RequestMetadata?
        var data: [Int: Vehicle]?

        private enum CodingKeys: String, CodingKey {
            case data
            case status
            case meta
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            status = try container.decodeIfPresent(.status)
            meta = try container.decodeIfPresent(.meta)
            data = try container.decodeIfPresent(.data)
        }
    }
}
