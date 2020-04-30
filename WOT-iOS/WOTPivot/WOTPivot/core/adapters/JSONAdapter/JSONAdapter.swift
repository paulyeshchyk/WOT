//
//  JSONCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias OnRequestComplete = (WOTRequestProtocol?, Any?, Error?) -> Void

@objc
public protocol DataAdapterProtocol {
    @available(*, deprecated)
    @objc var appManager: WOTAppManagerProtocol? { get set }
    var uuid: UUID { get }
    var onComplete: OnRequestComplete? { get set }
    var onObjectDidParse: ContextAnyObjectErrorCompletion? { get set }
    func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?)
    init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?)
}

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    var onGetObjectJSON: ((JSON) -> JSON)? { get set }
}

@objc
public class JSONAdapter: NSObject, JSONAdapterProtocol {
    // MARK: NSObject -
    override public var hash: Int {
        return uuid.uuidString.hashValue
    }

    required public init(Clazz clazz: PrimaryKeypathProtocol.Type, request: WOTRequestProtocol, appManager: WOTAppManagerProtocol?) {
        self.modelClazz = clazz
        self.request = request
        self.appManager = appManager
        self.persistentStore = appManager?.persistentStore

        super.init()
        appManager?.logInspector?.log(OBJNewLog(request.description), sender: self)
    }

    deinit {
        appManager?.logInspector?.log(OBJFreeLog(request.description), sender: self)
    }

    // MARK: DataAdapterProtocol -
    public var appManager: WOTAppManagerProtocol?
    public let uuid: UUID = UUID()

    // MARK: JSONAdapterProtocol -
    public var onGetObjectJSON: ((JSON) -> JSON)?
    public var onComplete: OnRequestComplete?
    public var onObjectDidParse: ContextAnyObjectErrorCompletion?

    public func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?) {
        guard error == nil, let json = json else {
            appManager?.logInspector?.log(ErrorLog(error, details: request), sender: self)
            onComplete?(fromRequest, self, error)
            return
        }

        appManager?.logInspector?.log(JSONStartLog(""), sender: self)
        let keys = json.keys
        for (idx, key) in keys.enumerated() {
            //
            let extraction = extractSubJSON(from: json, by: key)
            findOrCreateObject(for: extraction, fromRequest: fromRequest) {context, managedObjectID, error in

                self.onObjectDidParse?(context, managedObjectID, error)

                if idx == (keys.count - 1) {
                    self.appManager?.logInspector?.log(JSONFinishLog(""), sender: self)
                    self.onComplete?(fromRequest, self, error)
                }
            }
        }
    }

    // MARK: Private -
    private let METAClass: Codable.Type = RESTAPIResponse.self
    private var persistentStore: WOTPersistentStoreProtocol?
    private let modelClazz: PrimaryKeypathProtocol.Type
    private let request: WOTRequestProtocol
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
            didReceiveJSON(nil, fromRequest: request, nil)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            if let swiftError = result.swiftError {
                didReceiveJSON(nil, fromRequest: request, swiftError)
            } else {
                didReceiveJSON(result.data, fromRequest: request, nil)
            }
        } catch let error {
            didReceiveJSON(nil, fromRequest: request, error)
        }
    }
}

extension JSONAdapter {
    private struct JSONExtraction {
        let identifier: Any
        let json: JSON
    }

    /**

     */
    private func extractSubJSON(from json: JSON, by key: AnyHashable ) -> JSONExtraction {
        guard let jsonByKey = json[key] as? JSON else {
            fatalError("invalid json for key")
        }
        let objectJson: JSON
        if let jsonExtractor = onGetObjectJSON {
            objectJson = jsonExtractor(jsonByKey)
        } else {
            objectJson = jsonByKey
        }
        let ident = onGetIdent(modelClazz, objectJson, key)
        return JSONExtraction(identifier: ident, json: objectJson)
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        let primaryKeyPath = Clazz.primaryKeyPath()

        if  primaryKeyPath.count > 0 {
            ident = json[primaryKeyPath] ?? key
        } else {
            ident = key
        }
        return ident
    }

    private func findOrCreateObject(for jsonExtraction: JSONExtraction, fromRequest: WOTRequestProtocol, callback: @escaping ContextAnyObjectErrorCompletion) {

        let parents = fromRequest.jsonLink?.pkCase?.plainParents ?? []
        let objCase = PKCase(parentObjects: parents)
        #warning("not working for guns: expected gun_id - received tag")
        objCase[.primary] = modelClazz.primaryKey(for: jsonExtraction.identifier as AnyObject)
        appManager?.logInspector?.log(JSONStartLog(objCase.description), sender: self)

        appManager?.coreDataProvider?.findOrCreateObject(by: self.modelClazz, andPredicate: objCase[.primary]?.predicate, callback: { (context, managedObjectID, error) in

            guard let managedObjectID = managedObjectID else {
                callback(context, nil, error)
                return
            }
            let managedObject = context.object(with: managedObjectID)
            guard error == nil else {
                callback(context, managedObjectID, error)
                return
            }

            do {
                try self.persistentStore?.mapping(context: context, object: managedObject, fromJSON: jsonExtraction.json, pkCase: objCase)
                self.appManager?.logInspector?.log(JSONFinishLog("\(objCase)"), sender: self)
                self.persistentStore?.stash(context: context, hint: objCase)
                //
                callback(context, managedObjectID, error)
            } catch let error {
                self.appManager?.logInspector?.log(ErrorLog(error, details: objCase), sender: self)
            }
        })
    }
}

// MARK: - LogMessageSender
extension JSONAdapter: LogMessageSender {
    public var logSenderDescription: String {
        return "JSONAdapter:\(String(describing: type(of: request)))"
    }
}
