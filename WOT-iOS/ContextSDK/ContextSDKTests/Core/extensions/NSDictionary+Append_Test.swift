//
//  NSDictionary+Append_Test.swift
//  ContextSDKTests
//
//  Created by Paul on 19.12.22.
//

@testable import ContextSDK
import XCTest

class NSDictionary_Append_Test: XCTestCase {
    func testMerge() throws {
        let dict: [AnyHashable: Any] = [1: "3", 2: "89"]
        let dictToMerge: [AnyHashable: Any] = [3: "900"]
        let result = dict.merge(with: dictToMerge)
        XCTAssert((result as NSDictionary).isEqual(to: [1: "3", 2: "89", 3: "900"]))
    }

    func testAppend() throws {
        var dict: [AnyHashable: Any] = [1: "3", 2: "89"]
        dict.append(with: [3: "900"])
        XCTAssert((dict as NSDictionary).isEqual(to: [1: "3", 2: "89", 3: "900"]))
    }

    func testDebugOutput() throws {
        let dict: [AnyHashable: Any] = ["1": "3", "2": "89", "3": "900"]
        let result = dict.debugOutput()
        XCTAssert(!result.isEmpty)
    }

    func testDictionaryAsURLQueryString() {
        let dict: [AnyHashable: String?] = ["lorem": nil]
        let result = dict.asURLQueryString()
        let array = result.split(separator: "&")
        XCTAssert(array.isEmpty)
    }

    func testEscapedValueForNonExistingKey() {
        let dict: NSDictionary = ["lorem": "ipsum"]
        let result = dict.escapedValue(key: "nonLorem")
        XCTAssert(result == nil)
    }

    func testEscapedValueForNonURLEncodableKey() {
        let dict: NSDictionary = ["lorem": NSNull()]
        let result = dict.escapedValue(key: "lorem")
        XCTAssert(result == nil)
    }

    func testEscapedValueForNSDictionary() {
        let dict: NSDictionary = ["lorem": ["ABC": "DEF"]]
        let result = dict.escapedValue(key: "lorem")
        XCTAssert(result == "ABC=DEF")
    }

    func testEscapedValueForDictionary() {
        let dict: [AnyHashable: Any] = ["lorem": ["ABC": "DEF"]]
        let result = dict.escapedValue(key: "lorem")
        XCTAssert(result == "ABC=DEF")
    }

    func testEscapedValueForExistingKey() {
        let dict: NSDictionary = ["lorem": "ipsum"]
        let result = dict.escapedValue(key: "lorem")
        XCTAssert(result == "ipsum")
    }

    func testMixedDictionaryAsURLQueryString() {
        let dict: [AnyHashable: Any] = ["lorem": "ipsum", "dolor": "sit", "amet": "consectetur", "array": ["1", "2"]]
        let result = dict.asURLQueryString()
        let array = result.split(separator: "&")
        XCTAssert(array.count == 4)
        XCTAssert(array[0] == "amet=consectetur")
        XCTAssert(array[1] == "array=1,2")
        XCTAssert(array[2] == "dolor=sit")
        XCTAssert(array[3] == "lorem=ipsum")
    }

    func testMixedAsURLQueryString() {
        let dict: NSDictionary = ["lorem": "ipsum", "dolor": "sit", "amet": "consectetur", "array": ["1", "2"]]
        let result = dict.asURLQueryString()
        let array = result.split(separator: "&")
        XCTAssert(array.count == 4)
        XCTAssert(array[0] == "amet=consectetur")
        XCTAssert(array[1] == "array=1,2")
        XCTAssert(array[2] == "dolor=sit")
        XCTAssert(array[3] == "lorem=ipsum")
    }
}
