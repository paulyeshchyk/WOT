//
//  JSONAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    var linker: JSONAdapterLinkerProtocol { get set }
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, logInspector: LogInspectorProtocol?, coreDataStore: WOTDataLocalStoreProtocol?, jsonAdapterLinker: JSONAdapterLinkerProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol)
}
