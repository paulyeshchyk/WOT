//
//  WOTPivotTemplates.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/1/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTPivotTemplateProtocol: NSObjectProtocol {
    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol
}

@objc
class WOTPivotMetaTypeConverter: NSObject {
    @objc
    static func nodeClass(for type: PivotMetadataType) -> WOTPivotNode.Type {
        switch type {
        case .filter: return WOTPivotFilterNode.self
        case .column: return WOTPivotColNode.self
        case .row: return WOTPivotRowNode.self
        case .data: return WOTPivotDataNode.self
        }
    }
}

@objc
class WOTPivotTemplateVehicleTier: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {

        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: L10n.wotKeyTier)
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel1, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel1)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel2, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel2)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel3, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel3)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel4, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel4)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel5, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel5)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel6, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel6)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel7, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel7)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel8, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel8)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel9, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel9)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLevel10, predicate: NSPredicate(format: "%K == CAST(%@,'NSDecimalNumber')", L10n.wotKeyLevel, L10n.wotIntegerLevel10)))

        return result
    }
}

@objc
class WOTPivotTemplateVehiclePremium: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: L10n.wotKeyIsPremium)
        result.addChild(pivotNodeClass.init(name: L10n.wotStringIsPremium, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyIsPremium, NSNumber(value: 1))))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringIsNotPremium, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyIsPremium, NSNumber(value: 0))))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleType: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: L10n.wotKeyType)
        result.addChild(pivotNodeClass.init(name: L10n.wotStringAtSpg, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyType, L10n.wotStringTankTypeAtSpg)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringLt, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyType, L10n.wotStringTankTypeLightTank)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringHt, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyType, L10n.wotStringTankTypeHeavyTank)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringMt, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyType, L10n.wotStringTankTypeMediumTank)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringSpg, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyType, L10n.wotStringTankTypeSpg)))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleNation: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: L10n.wotKeyNation)
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationChina, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationChina)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationCzech, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationCzech)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationFrance, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationFrance)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationGermany, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationGermany)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationItaly, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationItaly)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationJapan, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationJapan)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationPoland, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationPoland)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationSweden, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationSweden)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationUk, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationUk)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationUsa, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationUsa)))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringNationUssr, predicate: NSPredicate(format: "%K == %@", L10n.wotKeyNation, L10n.wotStringNationUssr)))
        return result
    }
}

@objc
class WOTPivotTemplateVehicleDPM: NSObject, WOTPivotTemplateProtocol {

    func asType(_ type: PivotMetadataType) -> WOTPivotNodeProtocol {
        let pivotNodeClass = WOTPivotMetaTypeConverter.nodeClass(for: type)
        let result = pivotNodeClass.init(name: L10n.wotKeyDpm)
        let predicateLess100 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 100)])
        let predicateLess200 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 100), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 200)])
        let predicateLess500 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 200), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 500)])
        let predicateLess1000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 500), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 1000)])
        let predicateLess2000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 1000), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 2000)])
        let predicateLess3000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 2000), NSPredicate(format: "%K < CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 3000)])
        let predicateGr3000 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "%K >= CAST(%d, 'NSDecimalNumber')", L10n.wotKeyDefaultProfileFireRate, 3000)])
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess100, predicate: predicateLess100))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess200, predicate: predicateLess200))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess500, predicate: predicateLess500))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess1000, predicate: predicateLess1000))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess2000, predicate: predicateLess2000))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmLess3000, predicate: predicateLess3000))
        result.addChild(pivotNodeClass.init(name: L10n.wotStringDpmGr3000, predicate: predicateGr3000))
        return result
    }
}

@objc
class WOTPivotTemplates: NSObject {

    @objc
    lazy var vehiclePremium: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehiclePremium()
    }()

    @objc
    lazy var vehicleType: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleType()
    }()

    @objc
    lazy var vehicleTier: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleTier()
    }()

    @objc
    lazy var vehicleNation: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleNation()
    }()

    @objc
    lazy var vehicleDPM: WOTPivotTemplateProtocol = {
        return WOTPivotTemplateVehicleDPM()
    }()
}
