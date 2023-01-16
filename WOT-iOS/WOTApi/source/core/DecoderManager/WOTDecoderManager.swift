//
//  WOTDecoderManager.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

public class WOTDecoderManager: DecoderManager {
    override public init() {
        super.init()
        register(jsonDecoder: VehiclesJSONDecoder.self, for: Vehicles.self)
        register(jsonDecoder: ModuleJSONDecoder.self, for: Module.self)
        register(jsonDecoder: ModulesTreeJSONDecoder.self, for: ModulesTree.self)
        register(jsonDecoder: VehicleprofileJSONDecoder.self, for: Vehicleprofile.self)
        register(jsonDecoder: VehicleprofileAmmoDamageJSONDecoder.self, for: VehicleprofileAmmoDamage.self)
        register(jsonDecoder: VehicleprofileAmmoJSONDecoder.self, for: VehicleprofileAmmo.self)
        register(jsonDecoder: VehicleprofileAmmoListJSONDecoder.self, for: VehicleprofileAmmoList.self)
        register(jsonDecoder: VehicleprofileAmmoPenetrationJSONDecoder.self, for: VehicleprofileAmmoPenetration.self)
        register(jsonDecoder: VehicleprofileArmorJSONDecoder.self, for: VehicleprofileArmor.self)
        register(jsonDecoder: VehicleprofileArmorListJSONDecoder.self, for: VehicleprofileArmorList.self)
        register(jsonDecoder: VehicleprofileEngineJSONDecoder.self, for: VehicleprofileEngine.self)
        register(jsonDecoder: VehicleprofileGunJSONDecoder.self, for: VehicleprofileGun.self)
        register(jsonDecoder: VehicleprofileModuleJSONDecoder.self, for: VehicleprofileModule.self)
        register(jsonDecoder: VehicleprofileRadioJSONDecoder.self, for: VehicleprofileRadio.self)
        register(jsonDecoder: VehicleprofileSuspensionJSONDecoder.self, for: VehicleprofileSuspension.self)
        register(jsonDecoder: VehicleprofileTurretJSONDecoder.self, for: VehicleprofileTurret.self)
    }
}
