//
//  JSONExtractorHelper.swift
//  ContextSDK
//
//  Created by Paul on 2.02.23.
//

// MARK: - JSONExtractorHelper

class JSONExtractorHelper {
    var modelClass: ModelClassType?
    var jsonRefs: [JSONRefProtocol]?
    var extractorType: ManagedObjectExtractable.Type?
    var completion: (([JSONMapProtocol]?, Error?) -> Void)?

    func run(json: JSON?) {
        guard let ExtractorType = extractorType else {
            completion?(nil, JSONExtractorHelperError.extractorTypeIsNotDefined(modelClass))
            return
        }
        let extractor = ExtractorType.init()
        do {
            let maps = try extractor.getJSONMaps(json: json,
                                                 modelClass: modelClass,
                                                 jsonRefs: jsonRefs)
            completion?(maps, nil)
        } catch {
            completion?(nil, error)
        }
    }
}

// MARK: - %t + JSONExtractorHelper.JSONExtractorHelperError

extension JSONExtractorHelper {
    enum JSONExtractorHelperError: Error, CustomStringConvertible {
        case jsonIsNil
        case modelClassIsNotDefined
        case extractorTypeIsNotDefined(ModelClassType?)

        public var description: String {
            switch self {
            case .jsonIsNil: return "\(type(of: self)): JSON is nil"
            case .modelClassIsNotDefined: return "\(type(of: self)): ModelClass is not defined"
            case .extractorTypeIsNotDefined(let modelClass): return "\(type(of: self)): Extractor is not defined for (\(String(describing: modelClass, orValue: "NULL")))"
            }
        }
    }
}
