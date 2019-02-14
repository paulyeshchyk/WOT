//
//  Tanks+DPM.h
//  WOT-iOS
//
//  Created on 8/25/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "Tanks+CoreDataClass.h"

@interface Tanks (DPM)

@property (nonatomic) NSNumber *dpm;
@property (nonatomic) NSNumber *visionRadius;
@property (nonatomic) NSNumber *speed;
@property (nonatomic) NSNumber *rotationSpeed;
@property (nonatomic) NSNumber *turretTraverseSpeed;
@property (nonatomic) NSNumber *powerToWeightRatio;
@property (nonatomic) NSNumber *armor;
@property (nonatomic) NSNumber *penetration;
@property (nonatomic) NSNumber *dispersion;
@property (nonatomic) NSNumber *aimingTime;

@property (nonatomic, readonly) NSString *invisibility;
@property (nonatomic) NSNumber *invisibilityShot;
@property (nonatomic) NSNumber *invisibilityImmobility;
@property (nonatomic) NSNumber *invisibilityMobility;

@end
