//
//  JSONCollectionProtocolTests.swift
//  ContextSDKTests
//
//  Created by Paul on 13.01.23.
//

@testable import ContextSDK
import XCTest

class JSONCollectionProtocolTests: XCTestCase {

    func testDataAsArray() {
        do {
            let array: [JSON] = [JSON()]
            let jsonMap = try JSONMap(array: array, predicate: ContextPredicate())
            let data = try jsonMap.data(ofType: [JSON].self)
            XCTAssert(data != nil, "data is nil")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDataAsElement() {
        do {
            let json = JSON()
            let jsonMap = try JSONMap(element: json, predicate: ContextPredicate())
            let data = try jsonMap.data(ofType: JSON.self)
            XCTAssert(data != nil, "data is nil")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDataAsCustom() {
        do {
            let string = "String"
            let collection = JSONCollection(custom: string)
            let data = try collection.data(ofType: String.self)
            XCTAssert(data != nil, "data is nil")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDataAsCustomButIncorrectType() {
        do {
            let string = "Lorem ips"
            let collection = JSONCollection(custom: string)
            let data = try collection.data(ofType: Int.self)
            XCTFail("should have an exception. because datatype is \(type(of: data))")
        } catch {
            XCTAssert(true)
        }
    }

    func testDataNilAsCustom() {
        do {
            let string: String? = nil
            let collection = JSONCollection(custom: string)
            let data = try collection.data(ofType: String.self)
            XCTAssert(data == nil)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
