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
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(node: node)
        model.add(node: node)
        model.add(node: node)
        model.add(node: node)
        XCTAssert(model.rootNodes.count == 4)
    }

    func testRemoveNode() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(node: node)
        XCTAssert(model.rootNodes.count == 1)
        model.remove(node: node)
        XCTAssert(model.rootNodes.count == 0)
    }

    func testRemoveAll() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(node: node)
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
    }

    func testAllObjects() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let node: WOTNodeSwift = WOTNodeSwift(name: "")
        model.add(node: node)
        XCTAssert(model.allObjects(sortComparator: nil).count == 1)
    }

    func testEndpoints() {
        model.removeAll()
        XCTAssert(model.rootNodes.count == 0)
        let parentnode: WOTNodeSwift = WOTNodeSwift(name: "")
        parentnode.addChild(WOTNodeSwift(name: ""))
        parentnode.addChild(WOTNodeSwift(name: ""))
        model.add(node: parentnode)
        XCTAssert(model.endpointsCount == 2)
    }
}
