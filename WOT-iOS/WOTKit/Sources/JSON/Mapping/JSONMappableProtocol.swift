//
//  JSONMapperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public protocol JSONMappableProtocol {
    typealias Context = DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol
    
    func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, inContext: JSONMappableProtocol.Context) throws
    func mapping(array: [Any], objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, inContext: JSONMappableProtocol.Context) throws
}
