//
//  JSONMapHelper.swift
//  ContextSDK
//
//  Created by Paul on 19.01.23.
//

// MARK: - JSONMapHelper

class JSONMapHelper {

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    let appContext: ResponseConfigurationProtocol.Context
    var extractor: ManagedObjectExtractable?
    var completion: (([JSONMapProtocol]?, Error?) -> Void)?
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
            completion?(nil, error)
            return
        }
        guard let json = json else {
            completion?(nil, Errors.jsonIsNil)
            return
        }
        guard let modelClass = modelClass else {
            completion?(nil, Errors.modelClassIsNil)
            return
        }
        let maps = extractor?.getJSONMaps(json: json, modelClass: modelClass, jsonRefs: contextPredicate?.jsonRefs)
        completion?(maps, (maps == nil) ? Errors.mapsAreNotCreated : nil)
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
