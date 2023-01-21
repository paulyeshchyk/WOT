//
//  ResponseConfigurationProtocol.swift
//  ContextSDK
//
//  Created by Paul on 18.01.23.
//

@objc
public protocol ResponseConfigurationProtocol {

    typealias WorkWithDataCompletion = (RequestProtocol, Error?) -> Void

    #warning("remove RequestManagerContainerProtocol & RequestRegistratorContainerProtocol")
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & UoW_ManagerContainerProtocol

    func handleData(_ data: Data?, fromRequest: RequestProtocol, forService: RequestModelServiceProtocol, inAppContext: Context, completion: WorkWithDataCompletion?)

}
