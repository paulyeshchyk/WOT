//
//  VehicleprofileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension Module: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Module.name),
                #keyPath(Module.nation),
                #keyPath(Module.tier),
                #keyPath(Module.type),
                #keyPath(Module.price_credit),
                #keyPath(Module.weight),
                #keyPath(Module.image)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Module.keypaths()
    }
}

extension Module {
    public typealias Fields = Void

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.radio_id = AnyConvertable(jSON[#keyPath(Module.radio_id)]).asNSDecimal
        self.suspension_id = AnyConvertable(jSON[#keyPath(Module.suspension_id)]).asNSDecimal
        self.engine_id = AnyConvertable(jSON[#keyPath(Module.engine_id)]).asNSDecimal
        self.gun_id = AnyConvertable(jSON[#keyPath(Module.gun_id)]).asNSDecimal
        self.turret_id = AnyConvertable(jSON[#keyPath(Module.turret_id)]).asNSDecimal
    }
}

extension Module {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestSubordinate(for: Module.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

extension Module: PrimaryKeypathProtocol {
    #warning("fakeModule_id")
    private static let pkey: String = #keyPath(Module.fakeModule_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
    }
}
