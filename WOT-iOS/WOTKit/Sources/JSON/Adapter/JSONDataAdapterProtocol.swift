//
//  JSONAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol
    
    var linker: JSONAdapterLinkerProtocol { get set }
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, jsonAdapterLinker: JSONAdapterLinkerProtocol)
}
