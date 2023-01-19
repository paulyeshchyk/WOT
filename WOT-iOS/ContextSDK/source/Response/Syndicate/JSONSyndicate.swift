//
//  JSONSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - JSONSyndicate

public class JSONSyndicate {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol

    public typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var linker: ManagedObjectLinkerProtocol?
    let appContext: Context?
    var modelClass: ModelClassType?
    var jsonMap: JSONMapProtocol?
    var decodeDepthLevel: DecodingDepthLevel?

    // MARK: Lifecycle

    init(appContext: Context?) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run() {
        guard decodeDepthLevel?.maxReached() ?? false else {
            completion?(nil, Errors.reachedMaxDecodingDepthLevel)
            return
        }

        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.linker = linker
        managedObjectLinkerHelper.modelClass = modelClass
        managedObjectLinkerHelper.completion = completion

        let mappingCoordinatorDecodeHelper = ManagedObjectDecodeHelper(appContext: appContext)
        mappingCoordinatorDecodeHelper.jsonMap = jsonMap
        mappingCoordinatorDecodeHelper.completion = { fetchResult, error in
            managedObjectLinkerHelper.run(fetchResult, error: error)
        }

        let datastoreFetchHelper = DatastoreFetchHelper(appContext: appContext)
        datastoreFetchHelper.modelClass = modelClass
        datastoreFetchHelper.nspredicate = jsonMap?.contextPredicate.nspredicate(operator: .and)
        datastoreFetchHelper.completion = { fetchResult, error in
            mappingCoordinatorDecodeHelper.run(fetchResult, error: error)
        }

        datastoreFetchHelper.run()
    }
}

extension JSONSyndicate {

    public static func decodeAndLink(appContext: Context?, jsonMap: JSONMapProtocol, modelClass: ModelClassType, managedObjectLinker: ManagedObjectLinkerProtocol?, decodingDepthLevel: DecodingDepthLevel?, completion: @escaping FetchResultCompletion) {
        let jsonSyndicate = JSONSyndicate(appContext: appContext)
        jsonSyndicate.jsonMap = jsonMap
        jsonSyndicate.modelClass = modelClass
        jsonSyndicate.linker = managedObjectLinker
        jsonSyndicate.decodeDepthLevel = decodingDepthLevel

        jsonSyndicate.completion = { fetchResult, error in
            completion(fetchResult, error)
        }
        jsonSyndicate.run()
    }
}

// MARK: - %t + JSONSyndicate.Errors

extension JSONSyndicate {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case jsonExtractorIsNotPresented
        case reachedMaxDecodingDepthLevel

        public var description: String {
            switch self {
            case .jsonExtractorIsNotPresented: return "\(type(of: self)): json extrator is not presented"
            case .reachedMaxDecodingDepthLevel: return "\(type(of: self)): Reached max decoding depth level"
            }
        }
    }
}
