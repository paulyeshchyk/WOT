//
//  WOTAppDelegateProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/12/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

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
