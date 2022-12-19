//
//  ErrorMixture.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public enum JSONAdapterLinkerError: Error {
    case wrongParentClass
    case wrongChildClass
}

public struct UnexpectedClassError: Error {
    var expected: AnyClass
    var received: AnyObject?
    public init(extected exp: AnyClass, received rec: AnyObject?) {
        self.expected = exp
        self.received = rec
    }
}

public enum RequestCoordinatorError: Error {
    case dataIsEmpty
    case requestNotFound
    case adapterNotFound(requestType: String)
    case modelClassNotFound(requestType: String)
    case requestClassNotFound(requestType: String)
}

public enum WOTCoredataStoreError: Error {
    case contextIsNotDefined
}

public enum ErrorVehicleprofileAmmoDamage: Error {
    case arrayIsNotContainingThreeElements
}

public enum ErrorVehicleprofileAmmoPenetration: Error {
    case arrayIsNotContainingThreeElements
}

public enum WOTCoreDataStoreError: Error, CustomDebugStringConvertible {
    // MARK: - Definition

    case objectNotCreated(AnyClass)
    case contextNotSaved

    // MARK: - Overrides

    public var debugDescription: String {
        switch self {
        case .objectNotCreated(let clazz): return "Object is not created:[\(String(describing: clazz))]"
        case .contextNotSaved: return "Context was not saved"
        }
    }
}

public enum WOTMapperError: Error, CustomDebugStringConvertible {
    case contextNotDefined
    case objectIDNotDefined
    case clazzIsNotSupportable(String)
    public var debugDescription: String {
        switch self {
        case .clazzIsNotSupportable(let clazz): return "Class is not supported by mapper:[\(String(describing: clazz))]"
        case .contextNotDefined: return "Context is not defined"
        case .objectIDNotDefined: return "ObjectID is not found"
        }
    }
}

public enum WOTRequestManagerError: Error, CustomDebugStringConvertible {
    case dataparserNotFound(RequestProtocol)
    case linkerNotFound(RequestProtocol)
    case receivedResponseFromReleasedRequest
    public var debugDescription: String {
        switch self {
        case .dataparserNotFound(let request): return "Dataparser not found for [\(String(describing: request))]"
        case .linkerNotFound(let request): return "Linker not found for [\(String(describing: request))]"
        case .receivedResponseFromReleasedRequest: return "Received response from released request"
        }
    }
}
