//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension ModulesTree: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(ModulesTree.name),
                #keyPath(ModulesTree.module_id),
                #keyPath(ModulesTree.price_credit),
                #keyPath(ModulesTree.next_guns),
                #keyPath(ModulesTree.next_tanks),
                #keyPath(ModulesTree.next_radios),
                #keyPath(ModulesTree.next_chassis),
                #keyPath(ModulesTree.next_engines),
                #keyPath(ModulesTree.next_modules),
                #keyPath(ModulesTree.next_turrets)
        ]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return ModulesTree.keypaths()
    }
}

extension ModulesTree {
    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
        case next_chassis
        case next_engines
        case next_guns
        case next_modules
        case next_radios
        case next_turrets
        case next_tanks
        case prevModules
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) {
        self.name = jSON[#keyPath(ModulesTree.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.module_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.is_default)] as? Bool ?? false)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_credit)] as? Int ?? 0)
        self.price_xp = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_xp)] as? Int ?? 0)

        /*
         *  availableTypes
         *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
         */
        self.type = jSON[#keyPath(ModulesTree.type)] as? String

        let requests: [WOTJSONLink]? = self.nestedRequests()
        linksCallback?(requests)
    }

    private func nestedRequests() -> [WOTJSONLink]? {
        return nil
//        let radio_id = self.radio_id?.stringValue
//        let requestRadio = JSONMappingNestedRequest(clazz: Tankradios.self, identifier_fieldname: #keyPath(Tankradios.module_id), identifier: radio_id, completion: { json in
//            guard let tankRadios = Tankradios.insertNewObject(context) as? Tankradios else { return }
//            tankRadios.mapping(fromJSON: json, into: context, completion: nil)
//            self.tankradios = tankRadios
//        })
//        return [requestRadio, requestEngine, requestGun, requestSuspension, requestTurret]
    }

    convenience init?(json: Any?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, linksCallback: OnLinksCallback?) {
        guard let json = json as? JSON, let entityDescription = ModulesTree.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)
        self.mapping(fromJSON: json, parentPrimaryKey: parentPrimaryKey, onSubordinateCreate: nil, linksCallback: linksCallback)
    }
}

extension ModulesTree {
    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? NSDecimalNumber else { return nil }
        return NSPredicate(format: "%K == %@", #keyPath(ModulesTree.module_id), ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: #keyPath(ModulesTree.module_id), value: ident, predicateFormat: "%K == %@")
    }
}
