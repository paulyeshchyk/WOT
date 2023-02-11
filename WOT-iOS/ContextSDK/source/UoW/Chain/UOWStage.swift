//
//  UOWStage.swift
//  ContextSDK
//
//  Created by Paul on 11.02.23.
//

// MARK: - UOWStage

enum UOWStage: Hashable {
    case initialization
    case unlinkFromParent(Int)
    case unlink(Int)
    case removeEmptyNode(Int)
}

// MARK: - UOWStage + Codable

extension UOWStage: Codable {
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
        let rawValue = try container.decode(UOWStageType.self, forKey: .rawValue)
        switch rawValue {
        case .initialization:
            self = .initialization
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
            try container.encode(UOWStageType.initialization.rawValue, forKey: .rawValue)
        case .unlinkFromParent(let subordinatesCount):
            try container.encode(UOWStageType.unlinkFromParent.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        case .unlink(let subordinatesCount):
            try container.encode(UOWStageType.unlink.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        case .removeEmptyNode(let subordinatesCount):
            try container.encode(UOWStageType.removeEmptyNode.rawValue, forKey: .rawValue)
            try container.encode(subordinatesCount, forKey: .associatedValue)
        }
    }
}

// MARK: - UOWStageType

@objc
public enum UOWStageType: Int, Decodable {
    case initialization
    case unlinkFromParent
    case unlink
    case removeEmptyNode
}

extension UOWStage {

    static func stage(stageType: UOWStageType, subordinatesCount: Int) -> UOWStage {
        switch stageType {
        case .initialization: return .initialization
        case .unlinkFromParent: return .unlinkFromParent(subordinatesCount)
        case .unlink: return .unlink(subordinatesCount)
        case .removeEmptyNode: return .removeEmptyNode(subordinatesCount)
        }
    }

    var stageType: UOWStageType {
        switch self {
        case .initialization: return .initialization
        case .unlinkFromParent: return .unlinkFromParent
        case .unlink: return .unlink
        case .removeEmptyNode: return .removeEmptyNode
        }
    }
}
