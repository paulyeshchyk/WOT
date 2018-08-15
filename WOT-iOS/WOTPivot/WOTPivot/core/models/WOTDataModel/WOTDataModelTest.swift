//
//  WOTDataModelTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/11/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOTPivot

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
        let node = WOTNode(name: "")
        model.add(rootNode: node)
        model.add(rootNode: node)
        model.add(rootNode: node)
        model.add(rootNode: node)
        model.loadModel()
        XCTAssert(model.rootNodes.count == 4)
    }

    func testAddNodes() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let array = [WOTNode(name: ""), WOTNode(name: "1"), WOTNode(name: "2")]
        model.add(nodes: array)
        model.loadModel()
        XCTAssert(model.rootNodes.count == 3)
    }

    func testRemoveNode() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node = WOTNode(name: "")
        model.add(rootNode: node)
        XCTAssert(model.rootNodes.count == 1)
        model.remove(rootNode: node)
        model.loadModel()
        XCTAssert(model.rootNodes.count == 0)
    }

    func testRemoveNonExistedNode() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node = WOTNode(name: "")
        model.add(rootNode: node)
        XCTAssert(model.rootNodes.count == 1)
        let notExisted = WOTNode(name: "")
        model.remove(rootNode: notExisted)
        model.loadModel()
        XCTAssert(model.rootNodes.count == 1)
    }

    func testRemoveAll() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node = WOTNode(name: "")
        model.add(rootNode: node)
        model.clearRootNodes()
        model.loadModel()
        XCTAssert(model.rootNodes.count == 0)
    }

    func testAllObjects() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        model.add(rootNode: WOTNode(name: ""))
        model.add(rootNode: WOTNode(name: ""))
        model.loadModel()
        XCTAssert(model.nodesCount(section: 0) == 2)
    }

    func testEndpoints() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let parentnode = WOTNode(name: "")
        parentnode.addChild(WOTNode(name: ""))
        parentnode.addChild(WOTNode(name: ""))
        model.add(rootNode: parentnode)
        model.loadModel()
        XCTAssert(model.endpointsCount == 2)
    }

    func testIndex() {
        model.clearRootNodes()
        XCTAssert(model.rootNodes.count == 0)
        let node = WOTNode(name: "")
        model.add(rootNode: node)
        let node2 = WOTNode(name: "")
        node.addChild(node2)

        model.loadModel()

        guard let indexPath = model.indexPath(forNode: node2) else {
            XCTAssert(false, "index not found")
            return
        }
        XCTAssert(indexPath.compare(IndexPath(row: 0, section: 1)) == .orderedSame)

        let nodeToCheck = model.node(atIndexPath: IndexPath(row: 0, section: 1) as NSIndexPath)
        XCTAssert(nodeToCheck === node2)

        let node3: WOTNode? = nil
        let nonExistantIndexPath = model.indexPath(forNode: node3)
        XCTAssert(nonExistantIndexPath == nil)
    }
}
