//
//  PivotVIPER.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol PivotVIPERViewProtocol {

}

public protocol PivotVIPERInteractorProtocol {

}

public protocol PivotVIPERPresenterProtocol {

}

public protocol PivotVIPERWireFrameProtocol {
    
}

struct PivotVIPER {
    typealias View = PivotVIPERViewProtocol
    typealias Interactor = PivotVIPERInteractorProtocol
    typealias Presenter = PivotVIPERPresenterProtocol
    typealias WireFrame = PivotVIPERWireFrameProtocol
}
