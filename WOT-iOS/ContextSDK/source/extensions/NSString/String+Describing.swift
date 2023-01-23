//
//  String+Describing.swift
//  ContextSDK
//
//  Created by Paul on 9.01.23.
//

extension String {
    public init (describing: Any?, orValue: String) {
        guard let describing = describing else {
            self = orValue
            return
        }
        self = String(describing: describing)
    }
}
