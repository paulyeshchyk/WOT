//
//  Test_WOTRequestArguments.swift
//  ContextSDKTests
//
//  Created by Paul on 19.12.22.
//

import XCTest
@testable import ContextSDK

class Test_WOTRequestArguments: XCTestCase {

    func testInit() throws {
        let args = RequestArguments(["alpha":"beta"])
        let description = args.description
        XCTAssert(description == "{\n  \"alpha\" : [\n    \"beta\"\n  ]\n}")
    }
    
    func testHash() throws {
        let args = RequestArguments(["alpha":"beta"])
        XCTAssert(args.hash != 0)
    }

    func testDescription() throws {
        let args = RequestArguments(["alpha":"beta"])
        XCTAssert(args.description.count != 0)
    }

    func testSetValue() throws {
        let args = RequestArguments(["alpha":"beta"])
        args.setValues("zetta", forKey: "alpha")

        let result = args.buildQuery()
        XCTAssert(result == "alpha=zetta")
    }
    
    func testQuery() throws {
        let args = RequestArguments(["alpha":"beta"])

        let result = args.buildQuery()
        XCTAssert(result == "alpha=beta")
    }

}
