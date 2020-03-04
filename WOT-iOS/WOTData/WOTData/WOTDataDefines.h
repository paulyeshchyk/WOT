//
//  WOTDataDefines.h
//  WOTData
//
//  Created on 8/28/18.
//  Copyright © 2018. All rights reserved.
//

#ifndef WOTDataDefines_h
#define WOTDataDefines_h

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

#define WOT_KEY_ACCOUNT_ID @"account_id"
#define WOT_KEY_CODE @"code"
#define WOT_KEY_EXPIRES_AT @"expires_at"
#define WOT_KEY_HASHNAME @"hashName"
#define WOT_KEY_KEY @"key"
#define WOT_KEY_LOCATION @"location"
#define WOT_KEY_MESSAGE @"message"
#define WOT_KEY_DPM @"dpm"
#define WOT_KEY_NICKNAME @"nickname"
#define WOT_KEY_ORDERBY @"orderBy"
#define WOT_KEY_PRICES_XP @"prices_xp"

#define WOT_KEY_SETTING_TYPE @"WOT_KEY_SETTING_TYPE"
#define WOT_KEY_SETTING_TYPE_FILTER @"WOT_KEY_SETTING_TYPE_FILTER"
#define WOT_KEY_SETTING_TYPE_GROUP @"WOT_KEY_SETTING_TYPE_GROUP"
#define WOT_KEY_SETTING_TYPE_SORT @"WOT_KEY_SETTING_TYPE_SORT"
#define WOT_KEY_VEHICLES @"vehicles"
#define WOT_KEY_USER_ID @"userId"
#define WOT_KEY_VALUES @"values"
#define WOT_KEY_WEIGHT @"weight"
#define WOT_KEY_NEXT_TANKS @"next_tanks"

#define WOT_LINKKEY_DEFAULT_PROFILE @"default_profile"

#define WOT_VALUE_VEHICLE_GUN @"WOT_VALUE_VEHICLE_GUN"
#define WOT_VALUE_VEHICLE_ENGINE @"WOT_VALUE_VEHICLE_ENGINE"
#define WOT_VALUE_VEHICLE_TURRET @"WOT_VALUE_VEHICLE_TURRET"
#define WOT_VALUE_VEHICLE_CHASSIS @"WOT_VALUE_VEHICLE_CHASSIS"
#define WOT_VALUE_VEHICLE_RADIO @"WOT_VALUE_VEHICLE_RADIO"





#endif /* WOTDataDefines_h */
