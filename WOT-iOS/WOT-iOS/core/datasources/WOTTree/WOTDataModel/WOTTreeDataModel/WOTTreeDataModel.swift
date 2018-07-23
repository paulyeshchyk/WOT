//
//  WOTTreeDataModel.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

class WOTTreeDataModel: WOTDataModel, WOTTreeDataModelProtocol {

    var tankId: NSNumber? {
        didSet {
            //            do { try self.fetchController.performFetch() } catch { }
            guard let id = tankId else {
                return
            }

            let predicate = NSPredicate(format: "tank_id = %@", id)
            let context = WOTCoreDataProvider.sharedInstance().mainManagedObjectContext
            guard let tanks = Tanks.singleObject(with: predicate, in: context, includingSubentities: true) else {
                return
            }

            var plainList = [NSDecimalNumber: WOTNodeProtocol]()
            let rootNode = WOTNodeSwift(name: tanks.name_i18n)
            tanks.modulesTree.forEach { (module) in
                guard let moduleTree = module as? ModulesTree else {
                    return
                }
                let node = WOTTreeModuleNode(moduleTree: moduleTree)
                plainList[moduleTree.module_id] = node
                moduleTree.plainList(forVehicleId: id).forEach({ (child) in
                    guard let childModule = child as? ModulesTree else {
                        return
                    }
                    let childNode = WOTNodeSwift(name: childModule.type)
                    plainList[childModule.module_id] = childNode
                })
            }

            plainList.forEach { (_, node) in
                guard let moduleNode = node as? WOTTreeModuleNodeProtocol else {
                    return
                }
                guard let prevModule = moduleNode.modulesTree.prevModules else {
                    return
                }
                guard let parentId = prevModule.module_id else {
                    return
                }
                if let parentNode = plainList[parentId] {
                    parentNode.addChild(moduleNode)
                } else {
                    rootNode.addChild(moduleNode)
                }
            }

            self.add(rootNode: rootNode)
        }
    }

    var fetchController: WOTDataFetchControllerProtocol
    var listener: WOTDataModelListener
    required init(fetchController fetch: WOTDataFetchControllerProtocol, listener list: WOTDataModelListener) {
        fetchController = fetch
        listener = list
        super.init()

        self.fetchController.setListener(self)
    }

    private func failPivot(_ error: Error) {
        listener.modelDidFailLoad(error: error)
    }

    fileprivate func makeTree() {
        self.listener.modelDidLoad()
    }
}

extension WOTTreeDataModel: WOTDataFetchControllerListenerProtocol {

    func fetchPerformed(by: WOTDataFetchControllerProtocol) {
        self.makeTree()
    }

    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        self.failPivot(withError)
    }
}
