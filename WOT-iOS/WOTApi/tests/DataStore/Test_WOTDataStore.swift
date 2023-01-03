//
//  Test_WOTDataStore.swift
//  WOTApiTests
//
//  Created by Paul on 21.12.22.
//

@testable import ContextSDK
@testable import WOTApi
import XCTest

// MARK: - tempLogInspectorContainer

private class tempLogInspectorContainer: LogInspectorContainerProtocol {
    var logInspector: LogInspectorProtocol?
}

// MARK: - Test_DataStore

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
