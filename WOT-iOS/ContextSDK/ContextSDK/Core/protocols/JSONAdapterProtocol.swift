//
//  JSONAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol RequestManagerListenerProtocol {
    var uuidHash: Int { get }
    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)
    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol)
}

@objc
public protocol WOTRequestCoordinatorBridgeProtocol {
    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol
}

@objc
public protocol RequestManagerProtocol: WOTRequestCoordinatorBridgeProtocol {
    func addListener(_ listener: RequestManagerListenerProtocol?, forRequest: RequestProtocol)
    func removeListener(_ listener: RequestManagerListenerProtocol)
    func startRequest(_ request: RequestProtocol, withArguments arguments: RequestArgumentsProtocol, forGroupId: RequestIdType, jsonAdapterLinker: JSONAdapterLinkerProtocol) throws
    func startRequest(by requestId: RequestIdType, paradigm: MappingParadigmProtocol) throws
    func cancelRequests(groupId: RequestIdType, with error: Error?)
    func createRequest(forRequestId: RequestIdType) throws -> RequestProtocol
    func requestIds(forRequest request: RequestProtocol) -> [RequestIdType]
    func fetchRemote(paradigm: MappingParadigmProtocol)
}

@objc
public protocol RequestManagerContainerProtocol {
    @objc var requestManager: RequestManagerProtocol? { get set }
}

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & MappingCoordinatorContainerProtocol
    
    var linker: JSONAdapterLinkerProtocol { get set }
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: Context, jsonAdapterLinker: JSONAdapterLinkerProtocol)
}
