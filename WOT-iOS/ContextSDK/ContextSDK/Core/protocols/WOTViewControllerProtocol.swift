//
//  WOTViewControllerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import UIKit

@objc
public protocol WOTAppDelegateProtocol: LogInspectorContainerProtocol,
                                        DataStoreContainerProtocol,
                                        HostConfigurationContainerProtocol,
                                        ResponseParserContainerProtocol,
                                        RequestManagerContainerProtocol,
                                        RequestListenerContainerProtocol,
                                        SessionManagerContainerProtocol,
                                        RequestRegistratorContainerProtocol,
                                        MappingCoordinatorContainerProtocol,
                                        ResponseAdapterCreatorContainerProtocol {}

@objc
public protocol WOTViewControllerProtocol {
    var appManager: WOTAppDelegateProtocol? { get set }
}

@objc
open class WOTViewController: UIViewController, WOTViewControllerProtocol {
    public var appManager: WOTAppDelegateProtocol?
}
