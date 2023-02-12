//
//  UOWStatement.swift
//  ContextSDK
//
//  Created by Paul on 11.02.23.
//

// MARK: - UOWStatement

enum UOWStatement: Hashable {
    case initialization
    case link(Int)
    case unlinkFromParent(Int)
    case unlink(Int)
    case removeEmptyNode(Int)
}

// MARK: - UOWStatement + Codable

extension UOWStatement: Codable {
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }

    enum CodingError: Error {
        case unknownValue
    }

    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(UOWStatementType.self, forKey: .rawValue)
        switch rawValue {
        case .initialization:
            self = .initialization
        case .link:
            let subordinates = try container.decode(Int.self, forKey: .associatedValue)
            self = .link(subordinates)
        case .unlinkFromParent:
            let subordinates = try container.decode(Int.self, forKey: .associatedValue)
            self = .unlinkFromParent(subordinates)
        case .unlink:
            let subordinates = try container.decode(Int.self, forKey: .associatedValue)
            self = .unlink(subordinates)
        case .removeEmptyNode:
            let subordinates = try container.decode(Int.self, forKey: .associatedValue)
            self = .removeEmptyNode(subordinates)
        default:
            throw CodingError.unknownValue
        }
    }

    // MARK: Internal

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .initialization:
            try container.encode(UOWStatementType.initialization.rawValue, forKey: .rawValue)
        case .link(let subordinatesCount):
            try container.encode(UOWStatementType.link.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        case .unlinkFromParent(let subordinatesCount):
            try container.encode(UOWStatementType.unlinkFromParent.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        case .unlink(let subordinatesCount):
            try container.encode(UOWStatementType.unlink.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        case .removeEmptyNode(let subordinatesCount):
            try container.encode(UOWStatementType.removeEmptyNode.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        }
    }
}

// MARK: - UOWStatementType

@objc
public enum UOWStatementType: Int, Decodable {
    case initialization
    case link
    case unlinkFromParent
    case unlink
    case removeEmptyNode
}

extension UOWStatement {

    static func statement(type: UOWStatementType, subordinatesCount: Int) -> UOWStatement {
        switch type {
        case .initialization: return .initialization
        case .link: return .link(subordinatesCount)
        case .unlinkFromParent: return .unlinkFromParent(subordinatesCount)
        case .unlink: return .unlink(subordinatesCount)
        case .removeEmptyNode: return .removeEmptyNode(subordinatesCount)
        }
    }

    var statementType: UOWStatementType {
        switch self {
        case .initialization: return .initialization
        case .link: return .link
        case .unlinkFromParent: return .unlinkFromParent
        case .unlink: return .unlink
        case .removeEmptyNode: return .removeEmptyNode
        }
    }
}
