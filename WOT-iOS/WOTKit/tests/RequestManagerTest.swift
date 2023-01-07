//
//  RequestManagerTest.swift
//  WOTKitTests
//
//  Created by Paul on 3.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

@testable import ContextSDK
@testable import WOTApi
@testable import WOTKit
import XCTest

// MARK: - RequestManagerTest

class RequestManagerTest: XCTestCase {
    func testInit() throws {
        let appContext = AppContext()
        let requestManager = RequestManager(appContext: appContext)
        let managedObjectContext = ManagedObjectContext()
        let anchor = Anchor(identifier: "AnchorID", keypath: #keyPath(Anchor.keypath))
        let objectID = ObjectID()
        let extractor = Extractor()
        let fetchResult = FetchResult(objectID: objectID, managedObjectContext: managedObjectContext, predicate: nil, fetchStatus: .fetched)
        let linker = Linker(modelClass: PrimaryKeypath.self, masterFetchResult: fetchResult, anchor: anchor)
        let request = TestHttpRequest(context: appContext)
        let listener = Listener()
        listener.expectationDidStart = expectation(description: "didStart")
//        listener.expectationDidFinish = expectation(description: "didFinish")
//        listener.expectationDidCancel = expectation(description: "didCancel")
        listener.expectationDidFinishError = expectation(description: "didFinishError")

        do {
            try requestManager.startRequest(request, forGroupId: 1, managedObjectCreator: linker, managedObjectExtractor: extractor, listener: listener)
            XCTAssert(true)
        } catch {
            let descr = (error as CustomStringConvertible).description
            XCTAssert(false, descr)
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}

// MARK: - TestHttpRequest

class TestHttpRequest: HttpRequest {
    override var path: String { "/api" }
}

// MARK: - Listener

class Listener: RequestManagerListenerProtocol {

    init() {}

    var expectationDidFinish: XCTestExpectation?
    var expectationDidStart: XCTestExpectation?
    var expectationDidFinishError: XCTestExpectation?
    var expectationDidCancel: XCTestExpectation?

    var MD5: String { uuid.MD5 }

    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, error: Error?) {
        requestManager.removeListener(self)
        if error != nil {
            expectationDidFinishError?.fulfill()
        }
        expectationDidFinish?.fulfill()
    }

    func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        expectationDidStart?.fulfill()
    }

    func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        expectationDidCancel?.fulfill()
    }

    private let uuid = UUID()
}

// MARK: - Extractor

class Extractor: ManagedObjectExtractable {
    var linkerPrimaryKeyType: PrimaryKeyType = .internal

    func extractJSON(from _: JSON) -> JSON? {
        nil
    }
}

// MARK: - ObjectID

class ObjectID {}

// MARK: - Anchor

class Anchor: ManagedObjectLinkerAnchorProtocol {

    required init(identifier: Any?, keypath: KeypathType?) {
        self.identifier = identifier
        self.keypath = keypath
    }

    var identifier: Any?

    var keypath: KeypathType?

}

// MARK: - ManagedObjectContext

class ManagedObjectContext: ManagedObjectContextProtocol {
    var name: String? { "TestableManagedObjectContext" }

    func object(byID _: AnyObject) -> AnyObject? {
        nil
    }

    func findOrCreateObject(modelClass _: AnyObject, predicate _: NSPredicate?) -> ManagedObjectProtocol? {
        nil
    }

    func execute(appContext _: Context, with _: @escaping (ManagedObjectContextProtocol) -> Void) {
        // with()
    }

    func hasTheChanges() -> Bool {
        false
    }

    func save(appContext _: Context, completion block: @escaping ThrowableCompletion) {
        block(nil)
    }
}

// MARK: - PrimaryKeypath

class PrimaryKeypath: PrimaryKeypathProtocol {
    static func predicateFormat(forType: PrimaryKeyType) -> PredicateFormatProtocol {
        NSManagedObjectPredicateFormat(keyType: forType)
    }

    static func predicate(for _: AnyObject?, andType _: PrimaryKeyType) -> NSPredicate? {
        nil
    }

    static func primaryKeyPath(forType _: PrimaryKeyType) -> String {
        ""
    }

    static func primaryKey(forType _: PrimaryKeyType, andObject _: JSONValueType?) -> ContextExpressionProtocol? {
        nil
    }
}

// MARK: - Linker

class Linker: ManagedObjectLinkerProtocol {

    required init(modelClass _: PrimaryKeypathProtocol.Type, masterFetchResult _: FetchResultProtocol?, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    var MD5: String { uuid.MD5 }

    func process(fetchResult: FetchResultProtocol, appContext _: ManagedObjectLinkerContext, completion: @escaping ManagedObjectLinkerCompletion) {
        completion(fetchResult, nil)
    }

    private let uuid = UUID()
}

// MARK: - AppContext

class AppContext: ResponseDataAdapterCreatorContainerProtocol, RequestManagerContainerProtocol, MappingCoordinatorContainerProtocol, DataStoreContainerProtocol, HostConfigurationContainerProtocol, LogInspectorContainerProtocol {

    init() {
        hostConfiguration = HostConfiguration()
    }

    var dataStore: DataStoreProtocol?
    var hostConfiguration: HostConfigurationProtocol?
    var logInspector: LogInspectorProtocol?
    var mappingCoordinator: MappingCoordinatorProtocol?
    var requestManager: RequestManagerProtocol?
    var responseDataAdapterCreator: ResponseDataAdapterCreatorProtocol?
}

// MARK: - NSManagedObjectPredicateFormat

private class NSManagedObjectPredicateFormat: PredicateFormatProtocol {

    init(keyType: PrimaryKeyType) {
        self.keyType = keyType
    }

    public var template: String {
        switch keyType {
        case .external: return "%K == %@"
        case .internal: return "%K = %@"
        default: fatalError("unknown type should never be used")
        }
    }

    private let keyType: PrimaryKeyType
}

// MARK: - HostConfiguration

public class HostConfiguration: NSObject, HostConfigurationProtocol {

    public var applicationID: String {
        return "e3a1e0889ff9c76fa503177f351b853c"
    }

    public var host: String {
        return String(format: "%@.%@", WOTApiDefaults.applicationHost, "ru") // WOTApplicationDefaults.language()
    }

    public var scheme: String {
        return WOTApiDefaults.applicationScheme
    }

    override public var description: String {
        return "\(host):\(currentArguments)"
    }

    @objc
    public func urlQuery(with: RequestArgumentsProtocol?) -> String {
        let custom = ["application_id": applicationID]
        currentArguments = with?.buildQuery(custom) ?? ""
        return currentArguments
    }

    private var currentArguments: String = ""
}
