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
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(rootNode: node)
        model.add(rootNode: node)
        model.add(rootNode: node)
        model.add(rootNode: node)
        XCTAssert(model.rootNodes.count == 4)
    }

    func testRemoveNode() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(rootNode: node)
        XCTAssert(model.rootNodes.count == 1)
        model.remove(rootNode: node)
        XCTAssert(model.rootNodes.count == 0)
    }

    func testRemoveAll() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(rootNode: node)
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
    }

    func testAllObjects() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        model.add(rootNode: WOTNodeSwift(name: ""))
        model.add(rootNode: WOTNodeSwift(name: ""))
        XCTAssert(model.nodesCount(section: 0) == 2)
    }

    func testEndpoints() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let parentnode: WOTNodeSwift = WOTNodeSwift(name: "")
        parentnode.addChild(WOTNodeSwift(name: ""))
        parentnode.addChild(WOTNodeSwift(name: ""))
        model.add(rootNode: parentnode)
        XCTAssert(model.endpointsCount == 2)
    }
}
