//
//  WOTDataTanksFetchControllerTest.swift
//  WOT-iOSTests
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

@testable import ContextSDK
@testable import WOTPivot
import XCTest

class WOTDataTanksFetchControllerTest: XCTestCase {
//    class WOTRequestCountListener {
//        var asyncExpectation: XCTestExpectation?
//
//        static let notificationName = NSNotification.Name(rawValue: WOTRequestManager.pendingRequestNotificationName())
//
//        init() {
//            NotificationCenter.default.addObserver(self, selector: #selector(pendingRequestCountChaged(notification:)), name: WOTRequestCountListener.notificationName, object: nil)
//        }
//
//        deinit {
//            NotificationCenter.default.removeObserver(self, name: WOTRequestCountListener.notificationName, object: nil)
//        }
//
//        func performExecution() {
//            WOTApplicationDefaults.registerRequests()
//            WOTApplicationDefaults.registerDefaultSettings()
//        }
//
//        private var triggered: Bool = false
//
//        @objc
//        func pendingRequestCountChaged(notification: Notification) {
//            guard let executor = notification.object as? RequestManagerProtocol else {
//                return
//            }
//
//            let pendingRequests = executor.pendingRequestsCount
//            print("pendingRequests:\(pendingRequests)")
//
//            guard pendingRequests == 0 else {
//                return
//            }
//
//            guard !triggered else {
//                guard let expectation = asyncExpectation else {
//                    XCTFail("missing expectation")
//                    return
//                }
//
//                expectation.fulfill()
//
//                return
//            }
//            triggered = true
//        }
//    }
}

//
class TESTWOTDataTanksFetchControllerListener: NodeFetchControllerListenerProtocol {
    var asyncExpectation: XCTestExpectation?
    var result: [NodeProtocol]?
    var error: Error?

    lazy var predicates: [NSPredicate] = {
        return [NSPredicate]()
    }()

    func append(filters: [NSPredicate]) {
        predicates.append(contentsOf: filters)
    }

    func fetchPerformed(by: NodeFetchControllerProtocol) {
        guard let expectation = asyncExpectation else {
            XCTFail("missing expectation")
            return
        }
        by.fetchedNodes(byPredicates: predicates, nodeCreator: nil, filteredCompletion: { _, data in
            self.result = data as? [NodeProtocol]
            expectation.fulfill()
        })
    }

    func fetchFailed(by _: NodeFetchControllerProtocol, withError: Error) {
        guard let expectation = asyncExpectation else {
            XCTFail("missing expectation")
            return
        }
        error = withError
        expectation.fulfill()
    }
}
