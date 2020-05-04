//
//  ListSetting+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import WOTKit
import CoreData

@objc(ListSetting)
public class ListSetting: NSManagedObject {}

extension ListSetting: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        //let container = try decoder.container(keyedBy: Fields.self)
        //
    }
}
