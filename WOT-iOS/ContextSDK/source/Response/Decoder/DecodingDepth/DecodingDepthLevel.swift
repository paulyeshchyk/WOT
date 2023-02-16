//
//  DecodingDepthLevel.swift
//  ContextSDK
//
//  Created by Paul on 3.02.23.
//

// MARK: - DecodingDepthLevelProtocol

public protocol DecodingDepthLevelProtocol {
    var nextDepthLevel: DecodingDepthLevel { get }
    var isMaxLevelReached: Bool { get }
    static func limited(by: DecodingDepthLimit) -> DecodingDepthLevel
    static func unlimited() -> DecodingDepthLevel
}

// MARK: - DecodingDepthLevel

public class DecodingDepthLevel: NSObject, RawRepresentable {

    public typealias RawValue = Int
    public let rawValue: RawValue

    override public var description: String {
        return "[\(type(of: self))] rawValue: \(rawValue), limit: \(limit)"
    }

    private let limit: DecodingDepthLimit

    public required init(rawValue: RawValue) {
        self.rawValue = rawValue
        limit = .noLimit
        super.init()
    }

    public required init(rawValue: RawValue = 1, limit: DecodingDepthLimit) {
        self.rawValue = rawValue
        self.limit = limit
        super.init()
    }
}

// MARK: - DecodingDepthLevel + DecodingDepthLevelProtocol

extension DecodingDepthLevel: DecodingDepthLevelProtocol {

    public var nextDepthLevel: DecodingDepthLevel {
        DecodingDepthLevel(rawValue: rawValue + 1, limit: limit)
    }

    public var isMaxLevelReached: Bool {
        limit.limitReached(for: rawValue)
    }

    public static func limited(by: DecodingDepthLimit) -> DecodingDepthLevel {
        DecodingDepthLevel(limit: by)
    }

    public static func unlimited() -> DecodingDepthLevel {
        DecodingDepthLevel(limit: .noLimit)
    }
}
