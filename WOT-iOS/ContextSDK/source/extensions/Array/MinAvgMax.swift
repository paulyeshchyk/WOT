//
//  MinAvgMax.swift
//  ContextSDK
//
//  Created by Paul on 17.01.23.
//

// MARK: - MinAvgMax

public struct MinAvgMax {

    public let min_value: Double
    public let avg_value: Double
    public let max_value: Double

    // MARK: Lifecycle

    public init(_ array: [Double?]?) throws {
        guard let array = array?.compactMap({ $0 }) else {
            throw Errors.nilArray
        }
        guard array.count == 3 else {
            throw Errors.wrongArraySize
        }
        min_value = array[0]
        avg_value = array[1]
        max_value = array[2]
    }
}

// MARK: - Errors

private enum Errors: Error, CustomStringConvertible {
    case wrongArraySize
    case nilArray

    var description: String {
        switch self {
        case .wrongArraySize: return "Array size should be equal to 3"
        case .nilArray: return "Array is nil"
        }
    }
}

// MARK: - MinAvgMax + Decodable

extension MinAvgMax: Decodable {

    public enum CodingKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        min_value = try container.decode(.min_value)
        avg_value = try container.decode(.avg_value)
        max_value = try container.decode(.max_value)
    }

}

// MARK: - MinAvgMax + Encodable

extension MinAvgMax: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(min_value, forKey: .min_value)
        try container.encode(avg_value, forKey: .avg_value)
        try container.encode(max_value, forKey: .max_value)
    }
}

// MARK: - MinAvgMax + DecoderContainerProtocol

extension MinAvgMax: DecoderContainerProtocol {
    public func decoder() throws -> Decoder {
        let data = try JSONEncoder().encode(self)
        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
        return wrapper.decoder
    }
}
