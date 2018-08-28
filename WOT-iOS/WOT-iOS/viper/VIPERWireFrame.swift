//
//  VIPERRouter.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

protocol VIPERWireFrameProtocol: class {
    var presenter: VIPERPresenterProtocol? { get set }
    init()
}


typealias ConfigureCallback = (InitializedModule) -> Void

public class VIPERWireFrame: NSObject, VIPERWireFrameProtocol {
    var module: VIPERModule?
    var presenter: VIPERPresenterProtocol?

    required override public init() {
        super.init()
    }

    func build(configureCallback: ConfigureCallback) {

        let module = VIPERModule.module(for: self)
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
