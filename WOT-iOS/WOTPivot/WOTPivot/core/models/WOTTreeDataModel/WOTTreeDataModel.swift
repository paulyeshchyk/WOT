//
//  WOTTreeDataModel.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTTreeDataModel: WOTDataModel, WOTTreeDataModelProtocol {

    var tankId: NSNumber?

    override public func loadModel() {
        super.loadModel()
        do {
            try self.fetchController.performFetch()
        } catch let error {
            fetchFailed(by: self.fetchController, withError: error)
        }
    }

    var fetchController: WOTDataFetchControllerProtocol
    var listener: WOTDataModelListener
    required public init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener) {
        fetchController = fetch
        listener = list
        super.init()

        self.fetchController.setFetchListener(self)
    }

    fileprivate func failPivot(_ error: Error) {
        listener.modelDidFailLoad(error: error)
    }

    fileprivate func makeTree(_ fetchController: WOTDataFetchControllerProtocol) {
        let fetchedNodes = fetchController.fetchedNodes(byPredicates: [])
        self.add(nodes: fetchedNodes)
        self.listener.modelDidLoad()
    }
}

extension WOTTreeDataModel: WOTDataFetchControllerListenerProtocol {

    public func fetchPerformed(by fetchController: WOTDataFetchControllerProtocol) {
        self.makeTree(fetchController)
    }

    public func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        self.failPivot(withError)
    }
}
