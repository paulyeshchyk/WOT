//
//  WOTTankCoreDataProvider.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

@objc
public class WOTTankCoreDataProvider: WOTCoreDataProvider {
    override public var applicationDocumentsDirectoryURL: URL? {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
    }

    override public var modelURL: URL? {
        let bundles = Bundle.allFrameworks.compactMap { $0.bundleIdentifier?.compare("com.epam.WOTData") == .orderedSame ? $0 : nil }
        guard let bundle = bundles.last else {
            return nil
        }
        return bundle.url(forResource: "WOT_iOS", withExtension: "momd")
    }

    override public var sqliteURL: URL? {
        guard var result = self.applicationDocumentsDirectoryURL else {
            return nil
        }
        result.appendPathComponent("WOT_iOS.sqlite")
        return result
    }
}
