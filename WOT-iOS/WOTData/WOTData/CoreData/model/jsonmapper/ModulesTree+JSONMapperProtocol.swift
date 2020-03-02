//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension ModulesTree: JSONMapperProtocol {

    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
        case nextChassis
        case nextEngines
        case nextGuns
        case nextModules
        case nextRadios
        case nextTurrets
        case nextTanks
        case prevModules
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingCompletion?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?){
        
        defer {
            context.tryToSave()
            let requests: [JSONMappingNestedRequest]? = self.nestedRequests(context: context)
            completion?(requests)
        }

        self.name = jSON[#keyPath(ModulesTree.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.module_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.is_default)] as? Bool ?? false)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_credit)] as? Int ?? 0)
        self.price_xp = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_xp)] as? Int ?? 0)
        
        /**
         *  availableTypes
         *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
         */
        self.type = jSON[#keyPath(ModulesTree.type)] as? String

        
        if let nextChassis = jSON[#keyPath(ModulesTree.nextChassis)] {
            print(nextChassis)
        }
        if let nextEngines = jSON[#keyPath(ModulesTree.nextEngines)] {
            print(nextEngines)
        }
        if let nextGuns = jSON[#keyPath(ModulesTree.nextGuns)] {
            print(nextGuns)
        }
        if let nextModules = jSON[#keyPath(ModulesTree.nextModules)] {
            print(nextModules)
        }
        if let nextRadios = jSON[#keyPath(ModulesTree.nextRadios)] {
            print(nextRadios)
        }
        if let nextTurrets = jSON[#keyPath(ModulesTree.nextTurrets)] {
            print(nextTurrets)
        }
        if let nextTanks = jSON[#keyPath(ModulesTree.nextTanks)] {
            print(nextTanks)
        }
        if let prevModules = jSON[#keyPath(ModulesTree.prevModules)] {
            print(prevModules)
        }
    }
    
    
    
    private func nestedRequests(context: NSManagedObjectContext) -> [JSONMappingNestedRequest] {

//        let radio_id = self.radio_id?.stringValue
//        let requestRadio = JSONMappingNestedRequest(clazz: Tankradios.self, identifier_fieldname: #keyPath(Tankradios.module_id), identifier: radio_id, completion: { json in
//            guard let tankRadios = Tankradios.insertNewObject(context) as? Tankradios else { return }
//            tankRadios.mapping(fromJSON: json, into: context, completion: nil)
//            self.tankradios = tankRadios
//        })
//        return [requestRadio, requestEngine, requestGun, requestSuspension, requestTurret]
        return []
    }
}