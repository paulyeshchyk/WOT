//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - DecodableProtocol

public typealias DecoderObjC = Any

// MARK: - DecodableProtocol

@objc
public protocol DecodableProtocol {
    func decodeWith(_ decoder: DecoderObjC) throws
}

// MARK: - DecodableProtocolErrors

public enum DecodableProtocolErrors: Error {
    case notADecoder
}

extension DecodableProtocol {
    public func decode(decoderContainer: DecoderContainerProtocol?) throws {
        guard let decoderContainer = decoderContainer else {
            throw DecodableProtocolError.containerIsNil
        }
        try decodeWith(decoderContainer.decoder())
    }
}

// MARK: - DecodableProtocolError

private enum DecodableProtocolError: Error, CustomStringConvertible {
    case containerIsNil

    public var description: String {
        switch self {
        case .containerIsNil: return "[\(type(of: self))]: Container is nil"
        }
    }
}

// MARK: - JSONDecoderProtocol

@objc
public protocol JSONDecoderProtocol: AnyObject {

    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    var managedObject: ManagedAndDecodableObjectType? { get set }
    var jsonMap: JSONMapProtocol? { get set }
    var decodingDepthLevel: DecodingDepthLevel? { get set }
    var inContextOfWork: UOWProtocol? { get set }

    init(appContext: Context)
    func decode() throws
}

// MARK: - JSONCollectionProtocol

@objc
public protocol JSONCollectionProtocol {
    func data() -> Any?
}

extension JSONCollectionProtocol {

    public func data<T>(ofType _: T.Type) throws -> T {
        let dataToReturn = data()
        guard let resultToCheck = dataToReturn else {
            throw JSONCollectionDataError.dataIsNil
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
    case dataIsNil
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
