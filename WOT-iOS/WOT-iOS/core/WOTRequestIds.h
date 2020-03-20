//
//  WOTRequestIds.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

#ifndef WOTRequestIds_h
#define WOTRequestIds_h


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

#endif /* WOTRequestIds_h */
