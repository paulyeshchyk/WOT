//
//  WOTSaveSessionResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTSaveSessionResponseAdapter: NSObject {
    public var logInspector: LogInspectorProtocol?
    public var coreDataStore: WOTCoredataStoreProtocol?

    public required init(clazz: PrimaryKeypathProtocol.Type) {}
}
