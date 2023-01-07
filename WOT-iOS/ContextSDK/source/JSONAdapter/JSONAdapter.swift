//
//  JSONAdapter.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - JSONAdapter

open class JSONAdapter: JSONAdapterProtocol, CustomStringConvertible {

    public required init(modelClass: PrimaryKeypathProtocol.Type, request: RequestProtocol, managedObjectLinker: ManagedObjectLinkerProtocol, jsonExtractor: ManagedObjectExtractable, appContext: JSONAdapterProtocol.Context) {
        self.modelClass = modelClass
        self.request = request
        self.managedObjectLinker = managedObjectLinker
        self.jsonExtractor = jsonExtractor
        self.appContext = appContext
        appContext.logInspector?.log(.initialization(type(of: self)), sender: self)
    }

    deinit {
        appContext.logInspector?.log(.destruction(type(of: self)), sender: self)
    }

    open var responseClass: AnyClass {
        fatalError("has not been implemented")
    }

    open func decodedObject(jsonDecoder _: JSONDecoder, from _: Data) throws -> JSON? {
        fatalError("has not been implemented")
    }

    public var MD5: String { uuid.MD5 }

    // MARK: NSObject -

    public var description: String { String(describing: type(of: request)) }

    public func decode(data: Data?, fromRequest request: RequestProtocol, completion: ResponseAdapterProtocol.OnComplete?) {
        guard let data = data else {
            didFinish(request: request, data: nil, error: JSONAdapterError.dataIsNil, completion: completion)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decodedObject(jsonDecoder: decoder, from: data)
            didFinish(request: request, data: result, error: nil, completion: completion)
        } catch {
            let exception = JSONAdapterError.responseError(request, error)
            didFinish(request: request, data: nil, error: exception, completion: completion)
        }
    }

    // MARK: DataAdapterProtocol -

    private let uuid = UUID()
    private var managedObjectLinker: ManagedObjectLinkerProtocol
    private var jsonExtractor: ManagedObjectExtractable

    private let appContext: JSONAdapterProtocol.Context
    private let modelClass: PrimaryKeypathProtocol.Type
    private let request: RequestProtocol

    private func didFoundObject(_: FetchResultProtocol, error _: Error?) {}
}

public extension JSONAdapter {
    func didFinish(request: RequestProtocol, data: JSON?, error: Error?, completion fc: ResponseAdapterProtocol.OnComplete?) {
        guard error == nil, let json = data else {
            fc?(request, error ?? JSONAdapterError.jsonIsNil)
            return
        }

        let dispatchGroup = DispatchGroup()

        for key in json.keys {
            dispatchGroup.enter()
            //
            do {
                let contextPredicate = request.contextPredicate
                let extraction = try jsonExtractor.extract(json: json, key: key, forClazz: modelClass, contextPredicate: contextPredicate)

                let jsonElementLinker = JSONElementLinker(appContext: appContext, managedObjectLinker: managedObjectLinker)
                jsonElementLinker.completion = { _, error in
                    if let error = error {
                        fc?(request, error)
                    }
                    dispatchGroup.leave()
                }

                let jsonElementDecoder = JSONElementDecoder(appContext: appContext, jSON: extraction.json)
                jsonElementDecoder.completion = { fetchResult, error in
                    jsonElementLinker.link(fetchResult, error: error)
                }

                let jsonElementParser = JSONElementParser(appContext: appContext, jsonExtractiion: extraction, modelClass: modelClass)
                jsonElementParser.completion = { fetchResult, error in
                    jsonElementDecoder.predicate = jsonElementParser.predicate
                    jsonElementDecoder.decode(fetchResult, error: error)
                }

                try jsonElementParser.parse()

            } catch {
                fc?(request, error)
                dispatchGroup.leave()
                appContext.logInspector?.log(.error(error), sender: self)
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            fc?(request, nil)
        }
    }
}

// MARK: - JSONElementLinker

private class JSONElementLinker {
    init(appContext: DataStoreContainerProtocol, managedObjectLinker: ManagedObjectLinkerProtocol) {
        self.appContext = appContext
        self.managedObjectLinker = managedObjectLinker
    }

    var completion: ((FetchResultProtocol?, Error?) -> Void)?

    let appContext: DataStoreContainerProtocol
    let managedObjectLinker: ManagedObjectLinkerProtocol

    func link(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error)
            return
        }
        managedObjectLinker.process(fetchResult: fetchResult, appContext: appContext) { fetchResult, error in
            self.completion?(fetchResult, error)
        }
    }
}

// MARK: - JSONElementDecoder

private class JSONElementDecoder {
    init(appContext: (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol), jSON: JSONCollectionProtocol?) {
        self.appContext = appContext
        self.jSON = jSON
    }

    let appContext: (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)
    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    let jSON: JSONCollectionProtocol?
    var predicate: ContextPredicateProtocol?
    var managedObjectCreator: ManagedObjectLinkerProtocol?
    var managedObjectExtractor: ManagedObjectExtractable?

    func decode(_ fetchResult: FetchResultProtocol?, error: Error?) {
        guard let fetchResult = fetchResult, error == nil else {
            completion?(fetchResult, error)
            return
        }
        appContext.mappingCoordinator?.decode(using: jSON, fetchResult: fetchResult, predicate: predicate!, managedObjectCreator: managedObjectCreator, managedObjectExtractor: managedObjectExtractor, completion: { fetchResult, error in
            self.completion?(fetchResult, error)
        })
    }
}

// MARK: - JSONElementParser

private class JSONElementParser {
    //
    init(appContext: (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol), jsonExtractiion: JSONExtraction, modelClass: PrimaryKeypathProtocol.Type) {
        self.jsonExtractiion = jsonExtractiion
        self.modelClass = modelClass
        self.appContext = appContext
    }

    let appContext: (DataStoreContainerProtocol & MappingCoordinatorContainerProtocol)
    let jsonExtractiion: JSONExtraction
    let modelClass: PrimaryKeypathProtocol.Type

    var completion: ((FetchResultProtocol?, Error?) -> Void)?
    var linkingBlock: ((FetchResultProtocol) -> Void)?

    var predicate: ContextPredicateProtocol {
        jsonExtractiion.requestPredicate
    }

    func parse() throws {
        let nspredicate = predicate[.primary]?.predicate
        appContext.dataStore?.fetch(modelClass: modelClass, nspredicate: nspredicate, managedObjectContext: nil, completion: { fetchResult, error in
            self.completion?(fetchResult, error)
        })
    }

    private func findOrCreateObject(json _: JSONCollectionProtocol?, predicate _: ContextPredicateProtocol, completion _: @escaping FetchResultCompletion) throws {}
}

// MARK: - JSONAdapterError

private enum JSONAdapterError: Error, CustomStringConvertible {
    case jsonIsNil
    case dataIsNil
    case adapterIsNil
    case notMainThread
    case fetchResultIsNotPresented
    case jsonByKeyWasNotFound(JSON, AnyHashable)
    case notSupportedType(AnyClass)
    case responseError(RequestProtocol, Error)

    public var description: String {
        switch self {
        case .adapterIsNil: return "\(type(of: self)): Adapter is nil"
        case .jsonIsNil: return "\(type(of: self)): JSON is nil"
        case .dataIsNil: return "\(type(of: self)): Data is nil"
        case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adapted"
        case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
        case .notMainThread: return "\(type(of: self)): Not main thread"
        case .fetchResultIsNotPresented: return "\(type(of: self)): fetch result is not presented"
        case .responseError(let request, let error): return "[\(String(describing: request))]: \(String(describing: error))"
        }
    }
}
