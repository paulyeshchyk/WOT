//
//  UOWStatus.swift
//  ContextSDK
//
//  Created by Paul on 4.02.23.
//

typealias UOWStatusSubject = Hashable & Equatable & Comparable

// MARK: - UOWStatus

struct UOWStatus<T: UOWStatusSubject>: UOWStatusSubject {

    typealias StatementType = UOWStatement

    let subject: T
    let statement: StatementType

    // MARK: Lifecycle

    init(subject: T, statement: StatementType) {
        self.subject = subject
        self.statement = statement
    }

    // MARK: Internal

    static func == (lhs: UOWStatus, rhs: UOWStatus) -> Bool {
        return lhs.subject == rhs.subject && lhs.statement == rhs.statement
    }

    static func < (lhs: UOWStatus<T>, rhs: UOWStatus<T>) -> Bool {
        return lhs.subject < rhs.subject
    }
}

// MARK: - UOWStatus + Codable

extension UOWStatus: Codable where T == String {
    //
    enum CodingKeys: String, CodingKey {
        case subject
        case completed
    }

    init(from dictionary: [T: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        self = try decoder.decode(UOWStatus.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        subject = try container.decode(T.self, forKey: .subject)
        statement = try container.decode(StatementType.self, forKey: .completed)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(subject, forKey: .subject)
        try container.encode(statement, forKey: .completed)
    }
}

extension UOWStatus where T == String {
    func serialized<T>(type _: T.Type) throws -> T? {
        let data = try JSONEncoder().encode(self)
        let result = try JSONSerialization.jsonObject(with: data, options: [])
        return result as? T
    }
}

// MARK: - UOWStatusObjCWrapper

/// Generated by OpenAI
@objc
public class UOWStatusObjCWrapper: NSObject {
    private let structInstance: UOWStatus<String>

    override public var description: String {
        "[\(type(of: self))] subject: \(structInstance.subject), statement: \(structInstance.statement)"
    }

    @objc
    public init(subject: String, statementType: UOWStatementType, subordinatesCount: Int) {
        let statement = UOWStatement.statement(type: statementType, subordinatesCount: subordinatesCount)
        structInstance = UOWStatus<String>(subject: subject, statement: statement)
    }

    @objc
    public init(dictionary: [String: Any]?) throws {
        guard let dictionary = dictionary else { throw UOWStatusObjCWrapperError.dictionaryIsNil }
        structInstance = try UOWStatus(from: dictionary)
    }

    @objc
    public var subject: String {
        return structInstance.subject
    }

    @objc
    public var completed: Bool {
        switch structInstance.statement {
        case .initialization: return false
        case .link: return false
        case .removeEmptyNode(let subordinates): return subordinates == 0
        case .unlink(let subordinates): return subordinates == 0
        case .unlinkFromParent(let subordinates): return subordinates == 0
        }
    }

    private enum UOWStatusObjCWrapperError: Error {
        case dictionaryIsNil
    }
}
