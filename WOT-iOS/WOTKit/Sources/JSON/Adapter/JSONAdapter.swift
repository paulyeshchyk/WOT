//
//  JSONCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias OnParseComplete = (WOTRequestProtocol?, Any?, Error?) -> Void

@objc
public class JSONAdapter: NSObject, JSONAdapterProtocol {
    // MARK: DataAdapterProtocol -

    public let uuid: UUID = UUID()

    // MARK: JSONAdapterProtocol -

    public var onJSONDidParse: OnParseComplete?
    public var linker: JSONAdapterLinkerProtocol

    // MARK: Private -

    private var mappingCoordinator: WOTMappingCoordinatorProtocol
    private var coreDataStore: WOTCoredataStoreProtocol?
    private var logInspector: LogInspectorProtocol?
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
    private let requestManager: WOTRequestManagerProtocol
    private func didFoundObject(_ fetchResult: FetchResult, error: Error?) {}

    // MARK: NSObject -

    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    override public var description: String {
        return "JSONAdapter:\(String(describing: type(of: request)))"
    }

    public required init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, logInspector: LogInspectorProtocol?, coreDataStore: WOTCoredataStoreProtocol?, jsonAdapterLinker: JSONAdapterLinkerProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol) {
        self.modelClazz = clazz
        self.request = request
        self.linker = jsonAdapterLinker
        self.mappingCoordinator = mappingCoordinator
        self.logInspector = logInspector
        self.coreDataStore = coreDataStore
        self.requestManager = requestManager

        super.init()
        logInspector?.logEvent(EventObjectNew(request), sender: self)
    }

    deinit {
        logInspector?.logEvent(EventObjectFree(request), sender: self)
    }

    // MARK: JSONAdapterProtocol -

    public func didFinishJSONDecoding(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            logInspector?.logEvent(EventError(error, details: request), sender: self)
            onJSONDidParse?(fromRequest, self, error)
            return
        }

        let jsonStartParsingDate = Date()
        logInspector?.logEvent(EventJSONStart(fromRequest), sender: self)

        let dispatchGroup = DispatchGroup()

        json.keys.forEach { key in

            dispatchGroup.enter()
            //
            let extraction = self.linker.performJSONExtraction(from: json, byKey: key, forClazz: self.modelClazz, request: fromRequest)

            self.findOrCreateObject(json: extraction.json, requestPredicate: extraction.requestPredicate) { fetchResult, error in

                if let error = error {
                    self.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                    return
                }

                self.linker.process(fetchResult: fetchResult, coreDataStore: self.coreDataStore) { _, error in
                    if let error = error {
                        self.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.logInspector?.logEvent(EventJSONEnded(fromRequest, initiatedIn: jsonStartParsingDate), sender: self)
            self.onJSONDidParse?(fromRequest, self, error)
        }
    }
}

extension JSONAdapter {
    private func findOrCreateObject(json: JSON, requestPredicate: RequestPredicate, callback externalCallback: @escaping FetchResultErrorCompletion) {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            fatalError("thread is not main")
        }

        let localCallback: FetchResultErrorCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        coreDataStore?.fetchLocal(byModelClass: modelClazz, requestPredicate: requestPredicate[.primary]?.predicate, completion: { fetchResult, error in

            if let error = error {
                localCallback(fetchResult, error)
                return
            }

            let jsonStartParsingDate = Date()
            self.logInspector?.logEvent(EventJSONStart(requestPredicate), sender: self)
            self.mappingCoordinator.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: nil, requestManager: self.requestManager) { fetchResult, error in
                if let error = error {
                    self.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.logInspector?.logEvent(EventJSONEnded("\(String(describing: requestPredicate))", initiatedIn: jsonStartParsingDate), sender: self)
                localCallback(fetchResult, nil)
            }
        })
    }
}

public struct JSONExtraction {
    public let requestPredicate: RequestPredicate
    public let json: JSON
}

extension JSONAdapterLinkerProtocol {
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, request fromRequest: WOTRequestProtocol) -> JSONExtraction {
        guard let json = from[key] as? JSON else {
            fatalError("invalid json for key")
        }

        let extractedJSON = onJSONExtraction(json: json)

        let ident: Any
        if let primaryKeyPath = modelClazz.primaryKeyPath(forType: linkerPrimaryKeyType) {
            ident = extractedJSON[primaryKeyPath] ?? key
        } else {
            ident = key
        }

        let parents = fromRequest.paradigm?.requestPredicate()?.parentObjectIDList
        let requestPredicate = RequestPredicate(parentObjectIDList: parents)
        requestPredicate[.primary] = modelClazz.primaryKey(for: ident as AnyObject, andType: linkerPrimaryKeyType)

        return JSONExtraction(requestPredicate: requestPredicate, json: extractedJSON)
    }
}

// MARK: - Hash

func == (lhs: JSONAdapter, rhs: JSONAdapter) -> Bool {
    return lhs.uuid == rhs.uuid
}

// MARK: - private

extension DataAdapterProtocol {
    /**
     because of objC limitation, the function added as an extention to *JSONAdapterProtocol*
     */

    public func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: WOTRequestProtocol) where T: RESTAPIResponseProtocol {
        guard let data = binary else {
            didFinishJSONDecoding(nil, fromRequest: request, nil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            if let swiftError = result.swiftError {
                didFinishJSONDecoding(nil, fromRequest: request, swiftError)
            } else {
                didFinishJSONDecoding(result.data, fromRequest: request, nil)
            }
        } catch {
            didFinishJSONDecoding(nil, fromRequest: request, error)
        }
    }
}
