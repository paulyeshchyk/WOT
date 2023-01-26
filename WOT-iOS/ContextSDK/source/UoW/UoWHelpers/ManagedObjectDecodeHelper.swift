//
//  ManagedObjectDecodeHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - ManagedObjectDecodeHelper

class ManagedObjectDecodeHelper {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    private let appContext: Context
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?, error: Error?) {
        appContext.logInspector?.log(.flow(name: "moDecode", message: "start"), sender: self)
        do {
            guard let fetchResult = fetchResult, error == nil else {
                throw error ?? Errors.fetchResultIsNotPresented
            }
            guard let jsonMap = jsonMap else {
                throw Errors.contextPredicateIsNotDefined
            }

            try appContext.dataStore?.perform(mode: .readwrite, block: { managedObjectContext in

                do {
                    let managedObject = try fetchResult.managedObject(inManagedObjectContext: managedObjectContext)

                    guard let modelClass = type(of: managedObject) as? PrimaryKeypathProtocol.Type else {
                        throw Errors.modelClassIsNotDefined
                    }
                    #warning("Crash is here")
                    guard let decoderType = self.appContext.decoderManager?.jsonDecoder(for: modelClass) else {
                        throw Errors.decoderIsNotDefined
                    }

                    #warning("Provide crc check")
                    let decoder = decoderType.init(appContext: self.appContext)
                    decoder.managedObject = managedObject
                    try decoder.decode(using: jsonMap, forDepthLevel: DecodingDepthLevel.initial)

                    self.appContext.dataStore?.stash(managedObjectContext: managedObjectContext, completion: { _, error in
                        self.appContext.logInspector?.log(.flow(name: "moDecode", message: "finish"), sender: self)
                        self.completion?(fetchResult, error)
                    })
                } catch {
                    self.appContext.logInspector?.log(.flow(name: "moDecode", message: "finish"), sender: self)
                    self.completion?(fetchResult, error)
                }
            })
        } catch {
            appContext.logInspector?.log(.flow(name: "moDecode", message: "finish"), sender: self)
            completion?(fetchResult, error)
        }
    }
}

// MARK: - %t + ManagedObjectDecodeHelper.Errors

extension ManagedObjectDecodeHelper {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case contextNotFound
        case fetchResultIsNotPresented
        case contextPredicateIsNotDefined
        case fetchResultIsNotJSONDecodable(FetchResultProtocol?)
        case modelClassIsNotDefined
        case decoderIsNotDefined

        public var description: String {
            switch self {
            case .contextNotFound: return "[\(type(of: self))]: context not found"
            case .fetchResultIsNotJSONDecodable(let fetchResult): return "[\(type(of: self))]: fetch result(\(type(of: fetchResult)) is not JSONDecodableProtocol"
            case .contextPredicateIsNotDefined: return "\(type(of: self)): Context predicate is not defined"
            case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
            case .modelClassIsNotDefined: return "Model class is not defined"
            case .decoderIsNotDefined: return "Decoder is not defined"
            }
        }
    }

}
