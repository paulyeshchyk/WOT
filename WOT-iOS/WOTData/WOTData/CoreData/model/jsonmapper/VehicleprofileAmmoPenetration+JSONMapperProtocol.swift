//
//  VehicleprofileAmmoPenetration_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

@objc extension VehicleprofileAmmoPenetration: KeypathProtocol {
    @objc
    public static func keypaths() -> [String] {
        return [#keyPath(VehicleprofileAmmoPenetration.avg_value),
                #keyPath(VehicleprofileAmmoPenetration.max_value),
                #keyPath(VehicleprofileAmmoPenetration.min_value)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileAmmoPenetration.keypaths()
    }
}

extension VehicleprofileAmmoPenetration {
    public enum FieldKeys: String, CodingKey {
        case min_value
        case avg_value
        case max_valie
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        defer {
            coreDataMapping?.stash(pkCase)
        }
        self.min_value = AnyConvertable(array[0]).asNSDecimal
        self.avg_value = AnyConvertable(array[1]).asNSDecimal
        self.max_value = AnyConvertable(array[2]).asNSDecimal
    }
}

extension VehicleprofileAmmoPenetration {
    public static func penetration(fromArray array: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let array = array as? [Any] else { return }

        coreDataMapping?.pullLocalSubordinate(for: VehicleprofileAmmoPenetration.self, pkCase) { newObject in
            coreDataMapping?.mapping(object: newObject, fromArray: array, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}

#warning("add PrimaryKeypathProtocol support")
