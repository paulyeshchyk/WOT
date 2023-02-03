//
//  DecodingDepthLimit.swift
//  ContextSDK
//
//  Created by Paul on 3.02.23.
//

// MARK: - Limit

public enum DecodingDepthLimit: RawRepresentable {
    public static let NoLimit: Int = 0
    public static let First: Int = 1

    case noLimit
    case first
    case custom(Int)

    public var rawValue: Int {
        switch self {
        case .noLimit: return DecodingDepthLimit.NoLimit
        case .first: return DecodingDepthLimit.First
        case let .custom(value): return value
        }
    }

    // MARK: Lifecycle

    public init?(rawValue: Int) {
        switch rawValue {
        case DecodingDepthLimit.NoLimit: self = .noLimit
        case DecodingDepthLimit.First: self = .first
        case let value: self = .custom(value)
        }
    }

    // MARK: Internal

    func limitReached(for value: Int) -> Bool {
        switch self {
        case .noLimit: return false
        default: return (value > rawValue)
        }
    }
}
