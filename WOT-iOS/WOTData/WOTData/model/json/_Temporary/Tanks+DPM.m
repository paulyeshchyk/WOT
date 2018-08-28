//
//  Tanks+DPM.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+DPM.h"
#import <objc/runtime.h>
#import <WOTPivot/WOTPivot.h>

@implementation Tanks (DPM)
@dynamic dpm, visionRadius;
@dynamic invisibility, invisibilityShot, invisibilityImmobility, invisibilityMobility;
@dynamic speed, rotationSpeed, turretTraverseSpeed, powerToWeightRatio, armor, penetration, dispersion, aimingTime;


#pragma mark - getters / setters
static const void *SpeedRef = &SpeedRef;
- (NSNumber *)speed {
    
    NSNumber *result = objc_getAssociatedObject(self, SpeedRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:12.0f high:72.0f];
        [self setSpeed:result];
    }
    return result;
}

- (void)setSpeed:(NSNumber *)speed {
    
    objc_setAssociatedObject(self, SpeedRef, speed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *RotationSpeedRef = &RotationSpeedRef;
- (NSNumber *)rotationSpeed {
    
    NSNumber *result = objc_getAssociatedObject(self, RotationSpeedRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:0.0f high:48.0f];
        [self setRotationSpeed:result];
    }
    return result;
}

- (void)setRotationSpeed:(NSNumber *)rotationSpeed {
    
    objc_setAssociatedObject(self, RotationSpeedRef, rotationSpeed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *TurretTraverseSpeed = &TurretTraverseSpeed;
- (NSNumber *)turretTraverseSpeed {
    
    NSNumber *result = objc_getAssociatedObject(self, TurretTraverseSpeed);
    if (!result){
        
        result = [NSNumber randomValueForLow:0.0f high:48.0f];
        [self setTurretTraverseSpeed:result];
    }
    return result;
}

- (void)setTurretTraverseSpeed:(NSNumber *)turretTraverseSpeed {
    
    objc_setAssociatedObject(self, TurretTraverseSpeed, turretTraverseSpeed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *PowerToWeightRatioRef = &PowerToWeightRatioRef;
- (NSNumber *)powerToWeightRatio {
    
    NSNumber *result = objc_getAssociatedObject(self, PowerToWeightRatioRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:12.0f high:72.0f];
        [self setPowerToWeightRatio:result];
    }
    return result;
}

- (void)setPowerToWeightRatio:(NSNumber *)powerToWeightRatio {
    
    objc_setAssociatedObject(self, PowerToWeightRatioRef, powerToWeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *ArmorRef = &ArmorRef;
- (NSNumber *)armor {

    NSNumber *result = objc_getAssociatedObject(self, ArmorRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:1.0f high:400.0f];
        [self setArmor:result];
    }
    return result;
}

- (void)setArmor:(NSNumber *)armor {
    
    objc_setAssociatedObject(self, ArmorRef, armor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *PenetrationRef = &PenetrationRef;
- (NSNumber *)penetration {
    
    NSNumber *result = objc_getAssociatedObject(self, PenetrationRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:12.0f high:440.0f];
        [self setPenetration:result];
    }
    return result;
}

- (void)setPenetration:(NSNumber *)penetration {
    
    objc_setAssociatedObject(self, PenetrationRef, penetration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *DispersionRef = &DispersionRef;
- (NSNumber *)dispersion {
    
    NSNumber *result = objc_getAssociatedObject(self, DispersionRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:0.1f high:1.2f];
        [self setDispersion:result];
    }
    return result;
}

- (void)setDispersion:(NSNumber *)dispersion {
    
    objc_setAssociatedObject(self, DispersionRef, dispersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *AimingTimeRef = &AimingTimeRef;
- (NSNumber *)aimingTime {
    
    NSNumber *result = objc_getAssociatedObject(self, AimingTimeRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:0.1f high:80.0f];
        [self setAimingTime:result];
    }
    return result;
}

- (void)setAimingTime:(NSNumber *)aimingTime {
    
    objc_setAssociatedObject(self, AimingTimeRef, aimingTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)invisibility {
    
    NSString *invisibilityMobility = [self.invisibilityMobility suffixNumber];
    NSString *invisibilityImmobility = [self.invisibilityImmobility suffixNumber];
    NSString *invisibilityShot = [self.invisibilityShot suffixNumber];
    return [NSString stringWithFormat:@"%@/%@/%@",invisibilityImmobility, invisibilityMobility, invisibilityShot];
}

static const void *InvisibilityShotRef = &InvisibilityShotRef;
- (NSNumber *)invisibilityShot {
    
    NSNumber *result = objc_getAssociatedObject(self, InvisibilityShotRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:0.0f high:([self.invisibilityMobility floatValue]-1)];
        [self setInvisibilityShot:result];
    }
    return result;
}

- (void)setInvisibilityShot:(NSNumber *)invisibilityShot{
    
    objc_setAssociatedObject(self, InvisibilityShotRef, invisibilityShot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *InvisibilityMobilityRef = &InvisibilityMobilityRef;
- (NSNumber *)invisibilityMobility {
    
    NSNumber *result = objc_getAssociatedObject(self, InvisibilityMobilityRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:1.0f high:[self.invisibilityImmobility floatValue]];
        [self setInvisibilityMobility:result];
    }
    return result;
}

- (void)setInvisibilityMobility:(NSNumber *)invisibilityMobility{
    
    objc_setAssociatedObject(self, InvisibilityMobilityRef, invisibilityMobility, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *InvisibilityImmobilityRef = &InvisibilityImmobilityRef;
- (NSNumber *)invisibilityImmobility {
    
    NSNumber *result = objc_getAssociatedObject(self, InvisibilityImmobilityRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:12.0f high:18.0f];
        [self setInvisibilityImmobility:result];
    }
    return result;
}

- (void)setInvisibilityImmobility:(NSNumber *)invisibilityImmobility{
    
    objc_setAssociatedObject(self, InvisibilityImmobilityRef, invisibilityImmobility, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *VisionRadiusRef = &VisionRadiusRef;
- (NSNumber *)visionRadius {
    
    NSNumber *result = objc_getAssociatedObject(self, VisionRadiusRef);
    if (!result){
        
        result = [NSNumber randomValueForLow:250.0f high:480.0f];
        [self setVisionRadius:result];
    }
    return result;
}

- (void)setVisionRadius:(NSNumber *)visionRadius{
    
    objc_setAssociatedObject(self, VisionRadiusRef, visionRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const void *DPMRef = &DPMRef;
- (NSNumber *)dpm {
    
    NSNumber *result = objc_getAssociatedObject(self, DPMRef);
    if (!result){
        
        float low_bound = [self.level floatValue] * 25.0f;
        float high_bound = low_bound * 10;
        result = [NSNumber randomValueForLow:low_bound high:high_bound];
        [self setDpm:result];
    }
    return result;
}

- (void)setDpm:(NSNumber *)dpm{
    
    objc_setAssociatedObject(self, DPMRef, dpm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
