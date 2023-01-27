//
//  ManagedObjectDecodeHelper.swift
//  ContextSDK
//
//  Created by Paul on 16.01.23.
//

// MARK: - ManagedObjectDecodeHelper

class ManagedObjectDecodeHelper: CustomStringConvertible, CustomDebugStringConvertible {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    private let appContext: Context
    var description: String {
        "[\(type(of: self))] \(debugDescription)"
    }

    var debugDescription: String {
        ""
    }

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?
    private var decodingDepthLevel: DecodingDepthLevel?

    // MARK: Lifecycle

    init(appContext: Context, decodingDepthLevel: DecodingDepthLevel?) {
        self.appContext = appContext
        self.decodingDepthLevel = decodingDepthLevel
    }

    // MARK: Internal

    func run(_ fetchResult: FetchResultProtocol?) {
        //
        do {
            appContext.logInspector?.log(.uow("moDecode", message: "start \(String(describing: fetchResult, orValue: "<null>"))"), sender: self)

            guard let fetchResult = fetchResult else {
                throw Errors.fetchResultIsNotPresented
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

                    guard let decoderType = self.appContext.decoderManager?.jsonDecoder(for: modelClass) else {
                        throw Errors.decoderIsNotDefined
                    }

                    let decoder = decoderType.init(appContext: self.appContext)
                    decoder.managedObject = managedObject

                    try decoder.decode(using: jsonMap, decodingDepthLevel: self.decodingDepthLevel)

                    self.appContext.dataStore?.stash(managedObjectContext: managedObjectContext, completion: { _, error in
                        self.appContext.logInspector?.log(.uow("moDecode", message: "finish \(String(describing: fetchResult, orValue: "<null>"))"), sender: self)
                        self.completion?(fetchResult, error)
                    })
                } catch {
                    self.appContext.logInspector?.log(.uow("moDecode", message: "finish \(String(describing: fetchResult, orValue: "<null>"))"), sender: self)
                    self.completion?(fetchResult, error)
                }
            })
        } catch {
            appContext.logInspector?.log(.uow("moDecode", message: "finish \(String(describing: fetchResult, orValue: "<null>"))"), sender: self)
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
