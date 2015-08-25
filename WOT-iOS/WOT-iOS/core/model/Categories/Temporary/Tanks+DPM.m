//
//  Tanks+DPM.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/25/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "Tanks+DPM.h"
#import <objc/runtime.h>

@implementation Tanks (DPM)
@dynamic dpm, visionRadius;
@dynamic invisibility, invisibilityShot, invisibilityImmobility, invisibilityMobility;

#pragma mark - getters / setters
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
        
        float low_bound = 0.0f;
        float high_bound = [self.invisibilityMobility floatValue]-1;
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        result = @(rndValue);
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
        
        float low_bound = 1.0f;
        float high_bound = [self.invisibilityImmobility floatValue];
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        result = @(rndValue);
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
        
        float low_bound = 12.0f;
        float high_bound = 18.0f;
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        result = @(rndValue);
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
        
        float low_bound = 250.0f;
        float high_bound = 480.0f;
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        result = @(rndValue);
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
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        result = @(rndValue);
        [self setDpm:result];
    }
    return result;
}

- (void)setDpm:(NSNumber *)dpm{
    
    objc_setAssociatedObject(self, DPMRef, dpm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
