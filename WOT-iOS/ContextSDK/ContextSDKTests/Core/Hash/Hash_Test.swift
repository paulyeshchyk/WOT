//
//  Hash_Test.swift
//  ContextSDKTests
//
//  Created by Paul on 22.12.22.
//

import XCTest
@testable import ContextSDK

class MD5_Test: XCTestCase {

    func test_MD5() {
        let data: String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec"
        let md5Value = data.MD5()
        XCTAssert(md5Value == "7ae2ce44b938352a97f3987af13ed662")
    }
}
