//
//  WOTRequestFactory.swift
//  WOTApi
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

// MARK: - WOTWEBRequestFactory

@objc
public class WOTWEBRequestFactory: NSObject {
    //
    public typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & RequestRegistratorContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    private enum HttpRequestFactoryError: Error, CustomStringConvertible {
        case objectNotDefined

        public var description: String {
            switch self {
            case .objectNotDefined: return "[\(type(of: self))]: Object not defined"
            }
        }
    }

    // MARK: Public

    public static func fetchVehiclePivotData(appContext: Context) -> String {
        //
        let modelClass = Vehicles.self
        let modelFieldKeyPaths = modelClass.dataFieldsKeypaths()// modelClass.dataFieldsKeypaths()// modelClass.fieldsKeypaths()

        let uow = UOWRemote(appContext: appContext)
        uow.modelClass = modelClass
        uow.modelFieldKeyPaths = modelFieldKeyPaths
        uow.socket = nil
        uow.extractorType = Vehicles.PivotViewManagedObjectExtractor.self
        uow.contextPredicate = nil
        uow.decodingDepthLevel = DecodingDepthLevel.limited(by: .first)
        appContext.uowManager.run(unit: uow, inContextOfWork: nil) { result in
            if let error = result.error {
                appContext.logInspector?.log(.warning(error: error), sender: self)
            }
        }
        return uow.MD5
    }

    @objc
    @discardableResult
    public static func fetchVehicleTreeData(vehicleId: Int, appContext: Context) -> String {
        //

        let modelClass = Vehicles.self
        let modelFieldKeyPaths = modelClass.fieldsKeypaths()

        let composerInput = ComposerInput()
        composerInput.pin = JointPin(modelClass: modelClass, identifier: vehicleId, contextPredicate: nil)
        let composer = PrimaryKey_Composer()
        let contextPredicate = try? composer.build(composerInput)

        let uow = UOWRemote(appContext: appContext)
        uow.modelClass = modelClass
        uow.modelFieldKeyPaths = modelFieldKeyPaths
        uow.socket = nil
        uow.extractorType = Vehicles.TreeViewManagedObjectExtractor.self
        uow.contextPredicate = contextPredicate
        uow.decodingDepthLevel = DecodingDepthLevel.unlimited()
        appContext.uowManager.run(unit: uow, inContextOfWork: nil) { result in
            if let error = result.error {
                appContext.logInspector?.log(.warning(error: error), sender: self)
            }
        }
        return uow.MD5
    }
}
