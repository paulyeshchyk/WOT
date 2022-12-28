//
//  Test_WOTDataStore.swift
//  WOTApiTests
//
//  Created by Paul on 21.12.22.
//

import XCTest
@testable import WOTApi
@testable import ContextSDK

private class tempLogInspectorContainer: LogInspectorContainerProtocol {
    var logInspector: LogInspectorProtocol?
}

class Test_DataStore: XCTestCase {
    func test_modelurl() {
        let dataStore = WOTDataStore(appContext: tempLogInspectorContainer())
        let modelURL = dataStore.modelURL
        XCTAssert(modelURL != nil)
    }

    func test_sqliteurl() {
        let dataStore = WOTDataStore(appContext: tempLogInspectorContainer())
        let modelURL = dataStore.sqliteURL
        XCTAssert(modelURL != nil)
    }
}
