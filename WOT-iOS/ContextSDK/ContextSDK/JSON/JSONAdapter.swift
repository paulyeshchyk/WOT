//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

public class JSONAdapter: JSONAdapterProtocol, DescriptableProtocol {

    private enum JSONAdapterError: Error {
        case requestManagerIsNil
    }

    // MARK: DataAdapterProtocol -

    public var uuid: UUID { UUID() }
    public var MD5: String? { uuid.MD5 }

    // MARK: JSONAdapterProtocol -

    public var onJSONDidParse: OnParseComplete?
    public var linker: JSONAdapterLinkerProtocol

    // MARK: Private -

    private let context: JSONAdapterProtocol.Context
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol
    private func didFoundObject(_ fetchResult: FetchResultProtocol, error: Error?) {}

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public required init(Clazz clazz: PrimaryKeypathProtocol.Type, request: RequestProtocol, context: JSONAdapterProtocol.Context, jsonAdapterLinker: JSONAdapterLinkerProtocol) {
        self.modelClazz = clazz
        self.request = request
        self.linker = jsonAdapterLinker
        self.context = context

        context.logInspector?.logEvent(EventObjectNew(self), sender: self)
    }

    deinit {
        context.logInspector?.logEvent(EventObjectFree(self), sender: self)
    }

    // MARK: JSONAdapterProtocol -

    public func didFinishJSONDecoding(_ json: JSON?, fromRequest: RequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            context.logInspector?.logEvent(EventError(error, details: request), sender: self)
            onJSONDidParse?(fromRequest, error)
            return
        }

        let jsonStartParsingDate = Date()
        context.logInspector?.logEvent(EventJSONStart(fromRequest), sender: self)

        let dispatchGroup = DispatchGroup()

        json.keys.forEach { key in

            dispatchGroup.enter()
            //
            let extraction = linker.performJSONExtraction(from: json, byKey: key, forClazz: modelClazz, request: fromRequest)

            self.findOrCreateObject(json: extraction.json, requestPredicate: extraction.requestPredicate) {[weak self] fetchResult, error in
                guard let self = self else {
                    dispatchGroup.leave()
                    return
                }
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                    dispatchGroup.leave()
                    return
                }

                self.linker.process(fetchResult: fetchResult, dataStore: self.context.dataStore) { _, error in
                    if let error = error {
                        self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.context.logInspector?.logEvent(EventJSONEnded(fromRequest, initiatedIn: jsonStartParsingDate), sender: self)
            self.onJSONDidParse?(fromRequest, error)
        }
    }
}

extension JSONAdapter {
    private func findOrCreateObject(json: JSON, requestPredicate: RequestPredicate, callback externalCallback: @escaping FetchResultCompletion) {
        let currentThread = Thread.current
        guard currentThread.isMainThread else {
            fatalError("thread is not main")
        }

        let localCallback: FetchResultCompletion = { fetchResult, error in
            DispatchQueue.main.async {
                externalCallback(fetchResult, error)
            }
        }

        context.dataStore?.fetchLocal(byModelClass: modelClazz, requestPredicate: requestPredicate[.primary]?.predicate, completion: { fetchResult, error in

            if let error = error {
                localCallback(fetchResult, error)
                return
            }

            guard let requestManager = self.context.requestManager else {
                localCallback(fetchResult, JSONAdapterError.requestManagerIsNil)
                return
            }
            
            let jsonStartParsingDate = Date()
            self.context.logInspector?.logEvent(EventJSONStart(requestPredicate), sender: self)
            self.context.mappingCoordinator?.mapping(json: json, fetchResult: fetchResult, requestPredicate: requestPredicate, linker: nil, requestManager: requestManager) { fetchResult, error in
                if let error = error {
                    self.context.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
                self.context.logInspector?.logEvent(EventJSONEnded("\(String(describing: requestPredicate))", initiatedIn: jsonStartParsingDate), sender: self)
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
    public func performJSONExtraction(from: JSON, byKey key: AnyHashable, forClazz modelClazz: PrimaryKeypathProtocol.Type, request fromRequest: RequestProtocol) -> JSONExtraction {
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

// MARK: - private

extension DataAdapterProtocol {
    /**
     because of objC limitation, the function added as an extention to *JSONAdapterProtocol*
     */

    public func decode<T>(binary: Data?, forType type: T.Type, fromRequest request: RequestProtocol) where T: RESTAPIResponseProtocol {
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
