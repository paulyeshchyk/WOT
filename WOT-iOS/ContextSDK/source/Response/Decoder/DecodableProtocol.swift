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

// MARK: - DecodingDepthLevel

@objc

public class DecodingDepthLevel: NSObject, RawRepresentable {

    public required init?(rawValue: Int) {
        self.rawValue = rawValue
        maxLevel = nil
        super.init()
    }

    public required init?(rawValue: Int, maxLevel: Int?) {
        self.rawValue = rawValue
        self.maxLevel = maxLevel
        super.init()
    }

    public var rawValue: Int
    public var maxLevel: Int?

    override public var description: String {
        return "[\(type(of: self))] rawValue: \(rawValue), maxLevel: \(maxLevel ?? -1)"
    }

    public static func initial(maxLevel: Int? = nil) -> DecodingDepthLevel? {
        DecodingDepthLevel(rawValue: 0, maxLevel: maxLevel)
    }

    public typealias RawValue = Int

    public var nextDepthLevel: DecodingDepthLevel? {
        DecodingDepthLevel(rawValue: rawValue + 1, maxLevel: maxLevel)
    }

    // MARK: Public

    public func maxReached() -> Bool {
        guard let maxLevel = maxLevel else {
            return false
        }
        return rawValue > maxLevel
    }
}

// MARK: - JSONDecoderProtocol

@objc
public protocol JSONDecoderProtocol: AnyObject {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    var managedObject: ManagedAndDecodableObjectType? { get set }
    init(appContext: Context)
    func decode(using: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws
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
