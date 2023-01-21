//
//  MODecodeHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - MODecodeHelper

class MODecodeHelper {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UoW_ManagerContainerProtocol

    private let appContext: Context
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        do {
            guard let fetchResult = fetchResult, error == nil else {
                throw error ?? Errors.fetchResultIsNotPresented
            }
            guard let jsonMap = jsonMap else {
                throw Errors.contextPredicateIsNotDefined
            }

            let managedObject = try fetchResult.managedObject()

            guard let modelClass = type(of: managedObject) as? PrimaryKeypathProtocol.Type else {
                throw Errors.modelClassIsNotDefined
            }

            guard let decoderType = appContext.decoderManager?.jsonDecoder(for: modelClass) else {
                throw Errors.decoderIsNotDefined
            }

            let decoder = decoderType.init(appContext: appContext)
            decoder.managedObject = managedObject
            try decoder.decode(using: jsonMap, forDepthLevel: DecodingDepthLevel.initial)

            appContext.dataStore?.stash(fetchResult: fetchResult) { fetchResult, error in
                self.completion?(fetchResult, error)
            }
        } catch {
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + MODecodeHelper.Errors

extension MODecodeHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case fetchResultIsNotPresented
        case contextPredicateIsNotDefined
        case fetchResultIsNotJSONDecodable(FetchResultProtocol?)
        case modelClassIsNotDefined
        case decoderIsNotDefined

        public var description: String {
            switch self {
            case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
            case .contextPredicateIsNotDefined: return "\(type(of: self)): Context predicate is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            case .modelClassIsNotDefined: return "Model class is not defined"
            case .decoderIsNotDefined: return "Decoder is not defined"
            }
        }
    }

}
