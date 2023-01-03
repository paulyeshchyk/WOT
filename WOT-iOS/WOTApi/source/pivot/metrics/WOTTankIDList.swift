//
//  WOTTankIDList.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - WOTTanksIDListProtocol

@objc
public protocol WOTTanksIDListProtocol: NSObjectProtocol {
    var label: String { get }
    var allObjects: [String] { get }

    func addObject(_ object: String)
    func addObjects(_ objects: [String])
}

// MARK: - WOTTanksIDList

@objc
public class WOTTanksIDList: NSObject {

    @objc
    public required init(tankID: String) {
        super.init()
        addObject(tankID)
    }

    private(set) public var allObjects = [String]()

    public var label: String {
        return allObjects.joined(separator: "-")
    }

    func addObject(_ object: String) {
        allObjects.append(object)
    }

    func addObjects(_ objects: [String]) {
        allObjects.append(contentsOf: objects)
    }
}
