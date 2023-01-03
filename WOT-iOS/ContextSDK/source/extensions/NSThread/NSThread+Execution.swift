//
//  NSThread+Execution.swift
//  ContextSDK
//
//  Created by Paul on 3.01.23.
//

extension Thread {
    @objc
    public static func executeOnMain(completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async(execute: completion)
        }
    }
}
