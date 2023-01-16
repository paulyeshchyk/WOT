//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
public typealias JSONValueType = Any
public typealias KeypathType = Swift.AnyHashable
public typealias JSON = [KeypathType: JSONValueType]

// MARK: - DecodableProtocol

public protocol DecodableProtocol {
    func decodeWith(_ decoder: Decoder) throws
}

// MARK: - JSONDecodableProtocol

public protocol JSONDecodableProtocol {
    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    func decode(using: JSONMapProtocol, appContext: JSONDecodableProtocol.Context?) throws
}

// MARK: - JSONCollectionProtocol

@objc
public protocol JSONCollectionProtocol {
    func data() -> Any?
}

extension JSONCollectionProtocol {

    public func data<T>(ofType _: T.Type) throws -> T? {
        let dataToReturn = data()
        guard let resultToCheck = dataToReturn else {
            return nil
        }
        guard let result = resultToCheck as? T else {
            throw JSONCollectionDataError.cantbereturnedasrequestedtype
        }
        return result
    }
}

// MARK: - JSONCollectionDataError

private enum JSONCollectionDataError: Error {
    case incorrectTypeProvided
    case cantbereturnedasrequestedtype
    case cantbereturnedasrequestedtypebut(JSONCollectionType)
}

// MARK: - JSONCollectionType

@objc
public enum JSONCollectionType: Int, CustomStringConvertible {
    case element
    case array
    case custom

    public var description: String {
        switch self {
        case .element: return "element"
        case .array: return "array"
        case .custom: return "custom"
        }
    }
}
