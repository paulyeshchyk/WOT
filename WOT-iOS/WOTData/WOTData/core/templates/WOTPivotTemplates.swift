//
//  WOTPivotTemplates.swift
//  WOT-iOS
//
//  Created on 8/1/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTPivot

@objc
class WOTPivotTemplateVehicleTankID: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {

        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiKeys.tank_id)
        result.addChild(pivotNodeClass.init(name: "X", predicate: NSPredicate(format: "%K > 0", WOTApiKeys.tank_id)))

        return result
    }
}

@objc
class WOTPivotTemplateVehicleTier: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {

        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiKeys.tier)
        result.addChild(pivotNodeClass.init(name: "I", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "1")))
        result.addChild(pivotNodeClass.init(name: "II", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "2")))
        result.addChild(pivotNodeClass.init(name: "III", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "3")))
        result.addChild(pivotNodeClass.init(name: "IV", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "4")))
        result.addChild(pivotNodeClass.init(name: "V", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "5")))
        result.addChild(pivotNodeClass.init(name: "VI", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "6")))
        result.addChild(pivotNodeClass.init(name: "VII", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "7")))
        result.addChild(pivotNodeClass.init(name: "VIII", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "8")))
        result.addChild(pivotNodeClass.init(name: "IX", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "9")))
        result.addChild(pivotNodeClass.init(name: "X", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiKeys.tier, "10")))

        return result
    }
}

@objc
class WOTPivotTemplateVehiclePremium: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiKeys.is_premium)
        result.addChild(pivotNodeClass.init(name: "Is Premium", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.is_premium, NSNumber(value: 1))))
        result.addChild(pivotNodeClass.init(name: "Is not Premium", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.is_premium, NSNumber(value: 0))))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleType: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiKeys.type)
        result.addChild(pivotNodeClass.init(name: "ATSPG", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.type, WOTApiTankType.at_spg)))
        result.addChild(pivotNodeClass.init(name: "LT", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.type, WOTApiTankType.lightTank)))
        result.addChild(pivotNodeClass.init(name: "HT", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.type, WOTApiTankType.heavyTank)))
        result.addChild(pivotNodeClass.init(name: "MT", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.type, WOTApiTankType.mediumTank)))
        result.addChild(pivotNodeClass.init(name: "SPG", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.type, WOTApiTankType.spg)))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleNation: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiKeys.nation)
        result.addChild(pivotNodeClass.init(name: "china", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation     , "china")))
        result.addChild(pivotNodeClass.init(name: "czech", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation     , "czech")))
        result.addChild(pivotNodeClass.init(name: "france", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation    , "france")))
        result.addChild(pivotNodeClass.init(name: "germany", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation   , "germany")))
        result.addChild(pivotNodeClass.init(name: "italy", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation     , "italy")))
        result.addChild(pivotNodeClass.init(name: "japan", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation     , "japan")))
        result.addChild(pivotNodeClass.init(name: "poland", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation    , "poland")))
        result.addChild(pivotNodeClass.init(name: "sweden", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation    , "sweden")))
        result.addChild(pivotNodeClass.init(name: "uk", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation        , "uk")))
        result.addChild(pivotNodeClass.init(name: "usa", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation       , "usa")))
        result.addChild(pivotNodeClass.init(name: "ussr", predicate: NSPredicate(format: "%K == %@", WOTApiKeys.nation      , "ussr")))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleDPM: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: "DPM")
        let predicateLess100 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 100)])
        let predicateLess200 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 100), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 200)])
        let predicateLess500 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 200), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 500)])
        let predicateLess1000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 500), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 1000)])
        let predicateLess2000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 1000), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 2000)])
        let predicateLess3000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 2000), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 3000)])
        let predicateGr3000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 3000)])
        result.addChild(pivotNodeClass.init(name: "<100", predicate: predicateLess100))
        result.addChild(pivotNodeClass.init(name: "<200", predicate: predicateLess200))
        result.addChild(pivotNodeClass.init(name: "<500", predicate: predicateLess500))
        result.addChild(pivotNodeClass.init(name: "<1000", predicate: predicateLess1000))
        result.addChild(pivotNodeClass.init(name: "<2000", predicate: predicateLess2000))
        result.addChild(pivotNodeClass.init(name: "<3000", predicate: predicateLess3000))
        result.addChild(pivotNodeClass.init(name: ">=3000", predicate: predicateGr3000))
        return result
    }
}

@objc
public class WOTPivotTemplates: NSObject {

    @objc
    public lazy var tankID: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleTankID()
    }()

    @objc
    public lazy var vehiclePremium: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehiclePremium()
    }()

    @objc
    public lazy var vehicleType: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleType()
    }()

    @objc
    public lazy var vehicleTier: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleTier()
    }()

    @objc
    public lazy var vehicleNation: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleNation()
    }()

    @objc
    public lazy var vehicleDPM: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleDPM()
    }()
}
