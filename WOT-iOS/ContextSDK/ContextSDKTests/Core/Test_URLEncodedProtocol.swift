//
//  Test_URLEncodedProtocol.swift
//  ContextSDKTests
//
//  Created by Paul on 19.12.22.
//

@testable import ContextSDK
import XCTest

class Test_URLEncodedProtocol: XCTestCase {
    func testInt() throws {
        let value: Int = 1
        guard let result = value.urlEncoded() else {
            XCTFail("result is nil")
            return
        }
        XCTAssert(result == "1")
    }

    func testNSNumber() throws {
        let value: NSNumber = 1
        guard let result = value.urlEncoded() else {
            XCTFail("result is nil")
            return
        }
        XCTAssert(result == "1")
    }

    func testNSString() throws {
        let value: NSString = "Lorem ipsum"
        guard let result = value.urlEncoded() else {
            XCTFail("result is nil")
            return
        }
        XCTAssert(result == "Lorem%20ipsum")
    }

    func testArray() throws {
        let value: [String] = ["Lorem ipsum", "Dolor cit"]
        guard let result = value.urlEncoded() else {
            XCTFail("result is nil")
            return
        }
        XCTAssert(result == "Lorem%20ipsum,Dolor%20cit")
    }
}
