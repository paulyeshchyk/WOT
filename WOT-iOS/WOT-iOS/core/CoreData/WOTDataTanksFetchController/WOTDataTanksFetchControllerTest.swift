//
//  WOTDataTanksFetchControllerTest.swift
//  WOT-iOSTests
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import XCTest
@testable import WOTPivot

class WOTDataTanksFetchControllerTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
}

class WOTRequestCountListener {

    var asyncExpectation: XCTestExpectation?

    static let notificationName = NSNotification.Name(rawValue: WOTRequestExecutor.pendingRequestNotificationName())

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(pendingRequestCountChaged(notification:)), name: WOTRequestCountListener.notificationName, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: WOTRequestCountListener.notificationName, object: nil)
    }

    func performExecution() {
        WOTApplicationDefaults.registerRequests()
        WOTApplicationDefaults.registerDefaultSettings()
        WOTApplicationStartupRequests.executeAllStartupRequests()
    }

    private var triggered: Bool = false

    @objc
    func pendingRequestCountChaged(notification: Notification) {

        guard let executor = notification.object as? WOTRequestExecutor else {
            return
        }

        let pendingRequests = executor.pendingRequestsCount
        print("pendingRequests:\(pendingRequests)")

        guard pendingRequests == 0 else {
            return
        }

        guard !self.triggered else {

            guard let expectation = self.asyncExpectation else {
                XCTFail("missing expectation")
                return
            }

            expectation.fulfill()

            return
        }
        self.triggered = true
    }

}

class TESTWOTDataTanksFetchControllerListener: WOTDataFetchControllerListenerProtocol {

    var asyncExpectation: XCTestExpectation?
    var result: [WOTNodeProtocol]?
    var error: Error?

    lazy var predicates: [NSPredicate] = {
        return [NSPredicate]()
    }()

    func append(filters: [NSPredicate]) {
        self.predicates.append(contentsOf: filters)
    }

    func fetchPerformed(by: WOTDataFetchControllerProtocol) {
        guard let expectation = self.asyncExpectation else {
            XCTFail("missing expectation")
            return
        }
        self.result = by.fetchedNodes(byPredicates: self.predicates)
        expectation.fulfill()
    }

    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error) {
        guard let expectation = self.asyncExpectation else {
            XCTFail("missing expectation")
            return
        }
        self.error = withError
        expectation.fulfill()
    }

}