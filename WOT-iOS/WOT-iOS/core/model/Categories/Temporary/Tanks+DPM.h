//
//  Tanks+DPM.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks.h"

@interface Tanks (DPM)

@property (nonatomic) NSNumber *dpm;
@property (nonatomic) NSNumber *visionRadius;
@property (nonatomic) NSNumber *invisibilityShot;
@property (nonatomic) NSNumber *invisibilityImmobility;
@property (nonatomic) NSNumber *invisibilityMobility;
@property (nonatomic, readonly) NSString *invisibility;

@end
