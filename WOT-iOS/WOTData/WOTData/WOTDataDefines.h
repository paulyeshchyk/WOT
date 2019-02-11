//
//  WOTDataDefines.h
//  WOTData
//
//  Created by Pavel Yeshchyk on 8/28/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOTDataDefines_h
#define WOTDataDefines_h


typedef NS_ENUM(NSInteger, WOTModuleType){
    WOTModuleTypeUnknown  = 1 << 0,
    WOTModuleTypeChassis  = 1 << 1,
    WOTModuleTypeEngine = 1 << 2,
    WOTModuleTypeRadios = 1 << 3,
    WOTModuleTypeTurrets = 1 << 4,
    WOTModuleTypeGuns = 1 << 5,
    WOTModuleTypeTank = 1 << 6
};

typedef NS_ENUM(NSInteger, WOTRequestId) {
    WOTRequestIdLogin = 0,
    WOTRequestIdSaveSession,
    WOTRequestIdLogout,
    WOTRequestIdClearSession,
    WOTRequestIdTanks,
    WOTRequestIdTankEngines,
    WOTRequestIdTankChassis,
    WOTRequestIdTankTurrets,
    WOTRequestIdTankGuns,
    WOTRequestIdTankRadios,
    WOTRequestIdTankVehicles,
    WOTRequestIdTankProfile,
    WOTRequestIdModulesTree
};

#define WOT_VALUE_APPLICATION_ID_EU @"e3a1e0889ff9c76fa503177f351b853c"
#define WOT_VALUE_APPLICATION_ID_RU @"e3a1e0889ff9c76fa503177f351b853c"

#define WOT_KEY_ACCOUNT_ID @"account_id"
#define WOT_KEY_ARMOR_BOARD @"armor_board"
#define WOT_KEY_ARMOR_FEDD @"armor_fedd"
#define WOT_KEY_ARMOR_FOREHEAD @"armor_forehead"
#define WOT_KEY_CIRCULAR_VISION_RADIUS @"circular_vision_radius"
#define WOT_KEY_CODE @"code"
#define WOT_KEY_CONTOUR_IMAGE @"contour_image"
#define WOT_KEY_EXPIRES_AT @"expires_at"
#define WOT_KEY_FIRE_STARTING_CHANCE @"fire_starting_chance"
#define WOT_KEY_HASHNAME @"hashName"
#define WOT_KEY_IMAGE @"image"
#define WOT_KEY_IMAGE_SMALL @"image_small"
#define WOT_KEY_IS_PREMIUM @"is_premium"
#define WOT_KEY_KEY @"key"
#define WOT_KEY_DEFAULT_PROFILE_HP @"vehicles.default_profile.hp"
#define WOT_KEY_DEFAULT_PROFILE_WEIGHT @"vehicles.default_profile.weight"
#define WOT_KEY_DEFAULT_PROFILE_FIRE_RATE @"vehicles.default_profile.gun.fire_rate"
#define WOT_KEY_LOCATION @"location"
#define WOT_KEY_MAX_LOAD @"max_load"
#define WOT_KEY_MESSAGE @"message"
#define WOT_KEY_MODULES_TREE @"modules_tree"
#define WOT_KEY_DPM @"dpm"
#define WOT_KEY_NICKNAME @"nickname"
#define WOT_KEY_ORDERBY @"orderBy"
#define WOT_KEY_POWER @"power"
#define WOT_KEY_PRICES_XP @"prices_xp"
#define WOT_KEY_ROTATION_SPEED @"rotation_speed"

#define WOT_KEY_SETTING_TYPE @"WOT_KEY_SETTING_TYPE"
#define WOT_KEY_SETTING_TYPE_FILTER @"WOT_KEY_SETTING_TYPE_FILTER"
#define WOT_KEY_SETTING_TYPE_GROUP @"WOT_KEY_SETTING_TYPE_GROUP"
#define WOT_KEY_SETTING_TYPE_SORT @"WOT_KEY_SETTING_TYPE_SORT"
#define WOT_KEY_TYPE_I18N @"type_i18n"
#define WOT_KEY_VEHICLES @"vehicles"
#define WOT_KEY_USER_ID @"userId"
#define WOT_KEY_VALUES @"values"
#define WOT_KEY_WEIGHT @"weight"
#define WOT_KEY_NEXT_TANKS @"next_tanks"

#define WOT_LINKKEY_MODULESTREE @"modulestree"
#define WOT_LINKKEY_DEFAULT_PROFILE @"default_profile"
#define WOT_LINKKEY_ENGINES @"engines"
#define WOT_LINKKEY_GUNS @"guns"
#define WOT_LINKKEY_RADIOS @"radios"
#define WOT_LINKKEY_SUSPENSIONS @"suspensions"
#define WOT_LINKKEY_TURRETS @"turrets"

#define WOT_VALUE_VEHICLE_GUN @"WOT_VALUE_VEHICLE_GUN"
#define WOT_VALUE_VEHICLE_ENGINE @"WOT_VALUE_VEHICLE_ENGINE"
#define WOT_VALUE_VEHICLE_TURRET @"WOT_VALUE_VEHICLE_TURRET"
#define WOT_VALUE_VEHICLE_CHASSIS @"WOT_VALUE_VEHICLE_CHASSIS"
#define WOT_VALUE_VEHICLE_RADIO @"WOT_VALUE_VEHICLE_RADIO"


#define WOT_REQUEST_ID_TANK_LIST @"WOT_REQUEST_ID_TANK_LIST"
#define WOT_REQUEST_ID_LOGIN @"WOT_REQUEST_ID_LOGIN"
#define WOT_REQUEST_ID_LOGOUT @"WOT_REQUEST_ID_LOGOUT"
#define WOT_REQUEST_ID_VEHICLE_LIST @"WOT_REQUEST_ID_VEHICLE_LIST"
#define WOT_REQUEST_ID_VEHICLE_ITEM @"WOT_REQUEST_ID_VEHICLE_ITEM"
#define WOT_REQUEST_ID_VEHICLE_BY_TIER @"WOT_REQUEST_ID_VEHICLE_BY_TIER"
#define WOT_REQUEST_ID_VEHICLE_ADOPT @"WOT_REQUEST_ID_VEHICLE_ADOPT"
#define WOT_REQUEST_ID_VEHICLE_PROFILE @"WOT_REQUEST_ID_VEHICLE_PROFILE"



#endif /* WOTDataDefines_h */
