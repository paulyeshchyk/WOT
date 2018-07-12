//
//  WOTDataModelTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOT

class WOTDataModelTest: XCTestCase {

    lazy var model: WOTDataModelProtocol = {
        return WOTDataModel()
    }()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        XCTAssert(model.rootNodes.count == 0)
    }

    func testAddNode() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNode = WOTNode()
        model.add(node: node)
        model.add(node: node)
        model.add(node: node)
        model.add(node: node)
        XCTAssert(model.rootNodes.count == 1)
    }

    func testRemoveNode() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNode = WOTNode()
        model.add(node: node)
        XCTAssert(model.rootNodes.count == 1)
        model.remove(node: node)
        XCTAssert(model.rootNodes.count == 0)
    }

    func testRemoveAllNodes() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNode = WOTNode()
        model.add(node: node)
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
    }

    func testAllObjects() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNode = WOTNode()
        model.add(node: node)
        XCTAssert(model.allObjects(sortComparator: nil).count == 1)
    }

    func testEndpoints() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let parentnode = WOTNode()
        (parentnode as? WOTNodeProtocol)?.addChild(WOTNode())
        (parentnode as? WOTNodeProtocol)?.addChild(WOTNode())
        model.add(node: parentnode)
        XCTAssert(model.endpointsCount == 2)
    }
}
