//
//  WOTData.h
//  WOTData
//
//  Created on 8/27/18.
//  Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>


//! Project version number for WOTData.
FOUNDATION_EXPORT double WOTDataVersionNumber;

//! Project version string for WOTData.
FOUNDATION_EXPORT const unsigned char WOTDataVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WOTData/PublicHeader.h>

#import "WOTDataDefines.h"

//TODO: availableFields is internal method see nsmanagedobject+fillproperties

#import "ModulesTree+UI.h"
#import "WOTData+Mapping.h"

#import "WOTSessionManager.h"

#import "WOTCoreDataPredicates.h"

#import "WOTWEBRequestLogout.h"
#import "WOTWEBRequestLogin.h"
#import "WOTSaveSessionRequest.h"
#import "WOTClearSessionRequest.h"

#import "Vehicles+FillProperties.h"
#import "VehicleprofileAmmo+FillProperties.h"
#import "VehicleprofileAmmoList+FillProperties.h"
#import "VehicleprofileAmmoDamage+FillProperties.h"
#import "VehicleprofileEngine+FillProperties.h"
#import "VehicleprofileSuspension+FillProperties.h"
#import "Vehicleprofile+FillProperties.h"
#import "VehicleprofileRadio+FillProperties.h"
#import "VehicleprofileGun+FillProperties.h"
#import "VehicleprofileTurret+FillProperties.h"
#import "VehicleprofileAmmoPenetration+FillProperties.h"
#import "VehicleprofileArmor+FillProperties.h"

#import "Tankradios+FillProperties.h"
#import "Tankchassis+FillProperties.h"
#import "ModulesTree+CustomName.h"
#import "Tankengines+FillProperties.h"
#import "Tankturrets+FillProperties.h"
#import "Tankguns+FillProperties.h"
