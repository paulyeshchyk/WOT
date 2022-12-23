//
//  WOTViewControllerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import UIKit

@objc
public protocol ContextProtocol: LogInspectorContainerProtocol,
                                 DataStoreContainerProtocol,
                                 HostConfigurationContainerProtocol,
                                 //ResponseParserContainerProtocol,
                                 //RequestRegistratorContainerProtocol,
                                 //ResponseAdapterCreatorContainerProtocol,
                                 RequestManagerContainerProtocol,
                                 RequestListenerContainerProtocol,
                                 SessionManagerContainerProtocol,
                                 MappingCoordinatorContainerProtocol {}

@objc
public protocol ContextControllerProtocol {
    var context: ContextProtocol? { get set }
}
