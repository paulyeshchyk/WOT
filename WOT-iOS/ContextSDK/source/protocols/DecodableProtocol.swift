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

// MARK: - DecodingDepthLevel

@objc
public class DecodingDepthLevel: NSObject, RawRepresentable {
    public required init?(rawValue: Int) {
        self.rawValue = rawValue
        super.init()
    }

    public var rawValue: Int

    public static let initial: DecodingDepthLevel? = DecodingDepthLevel(rawValue: 0)

    public typealias RawValue = Int

    public var next: DecodingDepthLevel? { DecodingDepthLevel(rawValue: rawValue + 1) }

    // MARK: Public

    public func maxReached() -> Bool {
        rawValue < 1// (Int.max - 1)
    }

}

// MARK: - JSONDecodableProtocol

public protocol JSONDecodableProtocol {
    typealias Context = DataStoreContainerProtocol
        & RequestManagerContainerProtocol
        & LogInspectorContainerProtocol

    func decode(using: JSONMapProtocol, appContext: JSONDecodableProtocol.Context?, forDepthLevel: DecodingDepthLevel?) throws
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
