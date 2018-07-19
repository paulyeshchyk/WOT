//
//  WOTNode+ModuleTree.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/17/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

protocol WOTNodeModuleTreeProtocol {
    var moduleTree: ModulesTree? { get set }
    var moduleType: WOTModuleType? { get }
}

struct AssociationKeys {
    static var moduleTreeKey: Int = 0
}

extension WOTNodeSwift: WOTNodeModuleTreeProtocol {
    var moduleTree: ModulesTree? {
        get {

            return objc_getAssociatedObject(self, &AssociationKeys.moduleTreeKey) as? ModulesTree

        }

        set {

            objc_setAssociatedObject(self, &AssociationKeys.moduleTreeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

    }
    var moduleType: WOTModuleType? {
        return self.moduleTree?.moduleType()

    }

}

//@property (nonatomic, strong)ModulesTree *moduleTree;
//@property (nonatomic, readonly)WOTModuleType moduleType;
//
//- (id)initWithModuleTree:(ModulesTree *)module;
//- (void)setModuleTree:(ModulesTree *)moduleTree;
//- (ModulesTree *)moduleTree;
