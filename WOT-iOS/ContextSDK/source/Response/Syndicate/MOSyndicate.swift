//
//  JSONSyndicate.swift
//  ContextSDK
//
//  Created by Paul on 7.01.23.
//

// MARK: - MOSyndicate

public class MOSyndicate {

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    public typealias Context = LogInspectorContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol

    public typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    let appContext: Context
    var modelClass: ModelClassType?

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var jsonMap: JSONMapProtocol?
    var socket: JointSocketProtocol?

    // MARK: Lifecycle

    init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: Internal

    func run() {}
}

extension MOSyndicate {

    public static func fetch_decode_link(appContext: Context, jsonMaps: [JSONMapProtocol]?, modelClass: ModelClassType?, socket: JointSocketProtocol?, decodingDepthLevel: DecodingDepthLevel?, completion: @escaping FetchResultCompletion) {
        guard let jsonMaps = jsonMaps else {
            completion(nil, Errors.noMapsProvided)
            return
        }

        for (index, map) in jsonMaps.enumerated() {
            MOSyndicate.fetch_decode_link(appContext: appContext, jsonMap: map, modelClass: modelClass, socket: socket, decodingDepthLevel: decodingDepthLevel) { _, _ in
                let completed = (index == jsonMaps.count - 1)
                if completed {
                    completion(nil, nil)
                }
            }
        }
    }

    public static func fetch_decode_link(appContext: Context, jsonMap: JSONMapProtocol?, modelClass: ModelClassType?, socket: JointSocketProtocol?, decodingDepthLevel: DecodingDepthLevel?, completion: @escaping FetchResultCompletion) {
        guard decodingDepthLevel?.maxReached() ?? false else {
            completion(nil, Errors.reachedMaxDecodingDepthLevel)
            return
        }

        let managedObjectLinkerHelper = ManagedObjectLinkerHelper(appContext: appContext)
        managedObjectLinkerHelper.socket = socket
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

        datastoreFetchHelper.run(nil, error: nil)
    }
}

// MARK: - %t + MOSyndicate.Errors

extension MOSyndicate {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case jsonExtractorIsNotPresented
        case reachedMaxDecodingDepthLevel
        case noMapsProvided

        public var description: String {
            switch self {
            case .jsonExtractorIsNotPresented: return "\(type(of: self)): json extrator is not presented"
            case .reachedMaxDecodingDepthLevel: return "\(type(of: self)): Reached max decoding depth level"
            case .noMapsProvided: return "\(type(of: self)): No maps provided"
            }
        }
    }
}
