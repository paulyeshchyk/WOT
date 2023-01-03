//
//  WOTViewControllerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import UIKit

// MARK: - ContextProtocol

@objc
public protocol ContextProtocol: LogInspectorContainerProtocol,
    DataStoreContainerProtocol,
    HostConfigurationContainerProtocol,
    RequestManagerContainerProtocol,
    RequestListenerContainerProtocol,
    SessionManagerContainerProtocol,
    MappingCoordinatorContainerProtocol {}

// MARK: - ContextControllerProtocol

@objc
public protocol ContextControllerProtocol {
    var appContext: ContextProtocol? { get set }
}
