//
//  VIPERRouter.swift
//  WOT-iOS
//
//  Created on 8/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public protocol VIPERWireFrameProtocol: class {
    var presenter: VIPERPresenterProtocol? { get set }
    init()
}

public typealias ConfigureCallback = (InitializedModule) -> Void

public class VIPERWireFrame: NSObject, VIPERWireFrameProtocol {
    var module: VIPERModule?
    public var presenter: VIPERPresenterProtocol?

    required override public init() {
        super.init()
    }

    public func build(configureCallback: ConfigureCallback) {
//        let module = VIPERModule.module(for: self)
//        let initializedModule = VIPERModule.initialize(with: , interactor: <#T##VIPERInteractorProtocol#>, presenter: <#T##VIPERPresenterProtocol#>, wireFrame: <#T##VIPERWireFrameProtocol#>)
//        configureCallback(initializedModule)
    }

    func build(for view: VIPERView) -> InitializedModule? {
//        let _module = VIPERModule.moduleForWireframe(self)
//        let initializedModule = VIPERModule.initializedModule(withUserInterface: view,
//                                                              presenter: _module.presenter,
//                                                              interactor: _module.interactor,
//                                                              wireframe: self)

//        presenter?.didInitializeModule()
//        return initializedModule
        return nil
    }
}
