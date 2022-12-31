//
//  Hash_Test.swift
//  ContextSDKTests
//
//  Created by Paul on 22.12.22.
//

@testable import ContextSDK
import XCTest

class MD5_Test: XCTestCase {
    func test_MD5() {
        let data: String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec"
        do {
            let md5Value = try data.MD5()
            XCTAssert(md5Value == "7ae2ce44b938352a97f3987af13ed662")
        } catch {
            XCTFail("Cant convert to MD5")
        }
    }
}
