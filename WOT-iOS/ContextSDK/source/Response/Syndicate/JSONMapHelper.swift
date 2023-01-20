//
//  JSONMapHelper.swift
//  ContextSDK
//
//  Created by Paul on 19.01.23.
//

// MARK: - JSONMapHelper

class JSONMapHelper {

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    struct JSOMMapHelperResult {
        let map: JSONMapProtocol?
        let error: Error?
        let completed: Bool
    }

    let appContext: ResponseConfigurationProtocol.Context
    var extractor: ManagedObjectExtractable?
    var completion: ((JSOMMapHelperResult) -> Void)?
    var modelClass: ModelClassType?
    var contextPredicate: ContextPredicateProtocol?

    init(appContext: ResponseConfigurationProtocol.Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    func run(json: JSON?, error: Error?) {
        guard error == nil else {
            let result = JSOMMapHelperResult(map: nil, error: error, completed: false)
            completion?(result)
            return
        }
        guard let json = json else {
            let result = JSOMMapHelperResult(map: nil, error: Errors.jsonIsNil, completed: false)
            completion?(result)
            return
        }
        guard let modelClass = modelClass else {
            let result = JSOMMapHelperResult(map: nil, error: Errors.modelClassIsNil, completed: false)
            completion?(result)
            return
        }
        let extractedMaps = extractor?.getJSONMaps(json: json, modelClass: modelClass, jsonRefs: contextPredicate?.jsonRefs)
        guard let maps = extractedMaps else {
            let result = JSOMMapHelperResult(map: nil, error: Errors.mapsAreNotCreated, completed: false)
            completion?(result)
            return
        }
        for (index, map) in maps.enumerated() {
            let result = JSOMMapHelperResult(map: map, error: nil, completed: index == (maps.count - 1))
            completion?(result)
        }
    }
}

// MARK: - %t + JSONMapHelper.Errors

extension JSONMapHelper {
    enum Errors: Error {
        case jsonIsNil
        case modelClassIsNil
        case mapsAreNotCreated
    }
}
