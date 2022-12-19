//
//  WOTDataStoreProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias ThrowableCompletion = (Error?) -> Void

@objc
public protocol WOTDataStoreProtocol: NSObjectProtocol {
    func stash(block: @escaping ThrowableCompletion)
    func fetchLocal(byModelClass clazz: PrimaryKeypathProtocol.Type, requestPredicate predicate: NSPredicate?, completion: @escaping FetchResultErrorCompletion)
}
