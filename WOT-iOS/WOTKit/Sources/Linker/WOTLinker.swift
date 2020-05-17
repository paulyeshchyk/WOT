//
//  WOTLinker.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTLinker {
    private var logInspector: LogInspectorProtocol
    private var fetcherAndDecoder: WOTFetcherAndDecoder

    public init(logInspector: LogInspectorProtocol, fetcherAndDecoder: WOTFetcherAndDecoder) {
        self.logInspector = logInspector
        self.fetcherAndDecoder = fetcherAndDecoder
    }
}

public enum WOTLinkerError: Error, CustomDebugStringConvertible {
    case lookupRuleNotDefined
    case linkerNotStarted

    public var debugDescription: String {
        switch self {
        case .lookupRuleNotDefined: return "rule is not defined"
        case .linkerNotStarted: return "linker is not started"
        }
    }
}

// MARK: - WOTLinkerProtocol

extension WOTLinker: WOTLinkerProtocol {
    public func linkItems(from array: [Any]?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemsList = array else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTLinkerError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        fetcherAndDecoder.fetchLocalAndDecode(array: itemsList, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public func linkItem(from json: JSON?, masterFetchResult: FetchResult, linkedClazz: PrimaryKeypathProtocol.Type, mapperClazz: JSONAdapterLinkerProtocol.Type, lookupRuleBuilder: RequestPredicateComposerProtocol) {
        guard let itemJSON = json else { return }

        guard let lookupRule = lookupRuleBuilder.build() else {
            logInspector.logEvent(EventError(WOTLinkerError.lookupRuleNotDefined, details: nil), sender: self)
            return
        }

        let context = masterFetchResult.context

        let mapper = mapperClazz.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: lookupRule.objectIdentifier)
        fetcherAndDecoder.fetchLocalAndDecode(json: itemJSON, context: context, forClass: linkedClazz, requestPredicate: lookupRule.requestPredicate, mapper: mapper, callback: { [weak self] _, error in
            if let error = error {
                self?.logInspector.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }
}
