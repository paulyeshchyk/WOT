//
//  WOTPivotTemplates.swift
//  WOT-iOS
//
//  Created on 8/1/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import WOTKit
import WOTPivot

class WOTPivotTemplateVehicleTankID: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiFields.tank_id)
        result.addChild(pivotNodeClass.init(name: "X", predicate: NSPredicate(format: "%K > 0", WOTApiFields.tank_id)))

        return result
    }
}

class WOTPivotTemplateVehicleTier: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiFields.tier)
        result.addChild(pivotNodeClass.init(name: "I", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "1")))
        result.addChild(pivotNodeClass.init(name: "II", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "2")))
        result.addChild(pivotNodeClass.init(name: "III", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "3")))
        result.addChild(pivotNodeClass.init(name: "IV", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "4")))
        result.addChild(pivotNodeClass.init(name: "V", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "5")))
        result.addChild(pivotNodeClass.init(name: "VI", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "6")))
        result.addChild(pivotNodeClass.init(name: "VII", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "7")))
        result.addChild(pivotNodeClass.init(name: "VIII", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "8")))
        result.addChild(pivotNodeClass.init(name: "IX", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "9")))
        result.addChild(pivotNodeClass.init(name: "X", predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", WOTApiFields.tier, "10")))

        return result
    }
}

class WOTPivotTemplateVehiclePremium: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiFields.is_premium)
        result.addChild(pivotNodeClass.init(name: "Is Premium", predicate: NSPredicate(format: "%K == %@", WOTApiFields.is_premium, NSNumber(value: 1))))
        result.addChild(pivotNodeClass.init(name: "Is not Premium", predicate: NSPredicate(format: "%K == %@", WOTApiFields.is_premium, NSNumber(value: 0))))
        return result
    }
}

class WOTPivotTemplateVehicleType: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiFields.type)
        result.addChild(pivotNodeClass.init(name: "ATSPG", predicate: NSPredicate(format: "%K == %@", WOTApiFields.type, WOTApiTankType.at_spg)))
        result.addChild(pivotNodeClass.init(name: "LT", predicate: NSPredicate(format: "%K == %@", WOTApiFields.type, WOTApiTankType.lightTank)))
        result.addChild(pivotNodeClass.init(name: "HT", predicate: NSPredicate(format: "%K == %@", WOTApiFields.type, WOTApiTankType.heavyTank)))
        result.addChild(pivotNodeClass.init(name: "MT", predicate: NSPredicate(format: "%K == %@", WOTApiFields.type, WOTApiTankType.mediumTank)))
        result.addChild(pivotNodeClass.init(name: "SPG", predicate: NSPredicate(format: "%K == %@", WOTApiFields.type, WOTApiTankType.spg)))
        return result
    }
}

class WOTPivotTemplateVehicleNation: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: WOTApiFields.nation)
        result.addChild(pivotNodeClass.init(name: "china", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "china")))
        result.addChild(pivotNodeClass.init(name: "czech", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "czech")))
        result.addChild(pivotNodeClass.init(name: "france", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "france")))
        result.addChild(pivotNodeClass.init(name: "germany", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "germany")))
        result.addChild(pivotNodeClass.init(name: "italy", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "italy")))
        result.addChild(pivotNodeClass.init(name: "japan", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "japan")))
        result.addChild(pivotNodeClass.init(name: "poland", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "poland")))
        result.addChild(pivotNodeClass.init(name: "sweden", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "sweden")))
        result.addChild(pivotNodeClass.init(name: "uk", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "uk")))
        result.addChild(pivotNodeClass.init(name: "usa", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "usa")))
        result.addChild(pivotNodeClass.init(name: "ussr", predicate: NSPredicate(format: "%K == %@", WOTApiFields.nation, "ussr")))
        return result
    }
}

class WOTPivotTemplateVehicleDPM: PivotTemplateProtocol {
    func asType(_ type: PivotMetadataType) -> PivotNodeProtocol {
        let pivotNodeClass = PivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: "DPM")
        let predicateLess100 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K <  CAST(%d, 'NSDecimalNumber')", WOTApiForeignKeys.vehicles_default_profile_gun_fire_rate, 100)])
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

public struct WOTPivotTemplates {
    public init() {}

    public lazy var tankID: PivotTemplateProtocol = {
        return WOTPivotTemplateVehicleTankID()
    }()

    public lazy var vehiclePremium: PivotTemplateProtocol = {
        return WOTPivotTemplateVehiclePremium()
    }()

    public lazy var vehicleType: PivotTemplateProtocol = {
        return WOTPivotTemplateVehicleType()
    }()

    public lazy var vehicleTier: PivotTemplateProtocol = {
        return WOTPivotTemplateVehicleTier()
    }()

    public lazy var vehicleNation: PivotTemplateProtocol = {
        return WOTPivotTemplateVehicleNation()
    }()

    public lazy var vehicleDPM: PivotTemplateProtocol = {
        return WOTPivotTemplateVehicleDPM()
    }()
}
