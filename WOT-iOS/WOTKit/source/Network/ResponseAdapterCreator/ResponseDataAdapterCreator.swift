//
//  WOTResponseAdapterCreator.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class ResponseDataAdapterCreator: ResponseDataAdapterCreatorProtocol {

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & MappingCoordinatorContainerProtocol & RequestManagerContainerProtocol

    private enum ResponseAdapterCreatorError: Error, CustomStringConvertible {
        case adapterNotFound(requestType: RequestIdType)
        case modelClassNotFound(requestType: RequestIdType)

        var description: String {
            switch self {
            case .adapterNotFound(let requestType): return "\(type(of: self)): adapter not found \(requestType)"
            case .modelClassNotFound(let requestType): return "\(type(of: self)): model class not found \(requestType)"
            }
        }
    }

    private let appContext: Context
}
