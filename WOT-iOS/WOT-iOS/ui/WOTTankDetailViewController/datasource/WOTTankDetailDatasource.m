//
//  WOTTankDetailDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailDatasource.h"
#import "WOTTankDetailFieldKVO.h"

@interface WOTTankDetailDatasource ()

@property (nonatomic, strong)NSArray *sections;

@end

@implementation WOTTankDetailDatasource


- (id)init {
    
    self = [super init];
    if (self){
        
        WOTTankDetailSection *engines = [[WOTTankDetailSection alloc] initWithTitle:@"Engines" query:WOT_LINKKEY_ENGINES metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_ENGINES],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_POWER query:WOT_LINKKEY_ENGINES],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_ENGINES],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_FIRE_STARTING_CHANCE query:WOT_LINKKEY_ENGINES]
                                                                                                                                   ]];
        
        WOTTankDetailSection *chassis = [[WOTTankDetailSection alloc] initWithTitle:@"Suspensions" query:WOT_LINKKEY_SUSPENSIONS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_SUSPENSIONS],
                                                                                                                                           [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_SUSPENSIONS],
                                                                                                                                           [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_ROTATION_SPEED query:WOT_LINKKEY_SUSPENSIONS]
                                                                                                                                           ]];
        WOTTankDetailSection *guns = [[WOTTankDetailSection alloc] initWithTitle:@"Guns" query:WOT_LINKKEY_GUNS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_GUNS],
                                                                                                                          [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_GUNS],
                                                                                                                          [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_LEVEL query:WOT_LINKKEY_GUNS],
                                                                                                                          [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_RATE query:WOT_LINKKEY_GUNS]
                                                                                                                          ]];
        WOTTankDetailSection *turrets = [[WOTTankDetailSection alloc] initWithTitle:@"Turrets" query:WOT_LINKKEY_TURRETS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_ARMOR_BOARD query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_ARMOR_FEDD query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_ARMOR_FOREHEAD query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_LEVEL query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_CIRCULAR_VISION_RADIUS query:WOT_LINKKEY_TURRETS],
                                                                                                                                   [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_ROTATION_SPEED query:WOT_LINKKEY_TURRETS]
                                                                                                                                   ]];

        WOTTankDetailSection *radios = [[WOTTankDetailSection alloc] initWithTitle:@"Radios" query:WOT_LINKKEY_RADIOS metrics:@[[WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_NAME_I18N query:WOT_LINKKEY_RADIOS],
                                                                                                                                [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_PRICE_CREDIT query:WOT_LINKKEY_RADIOS],
                                                                                                                                [WOTTankDetailFieldKVO fieldWithFieldPath:WOT_KEY_DISTANCE query:WOT_LINKKEY_RADIOS]
                                                                                                                                ]];
        self.sections = @[guns,turrets,engines,chassis,radios];
        
    }
    return self;
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath sectionName:(NSString *)sectionName {
 
    return nil;
}

- (NSInteger)numberOfSections {
    
    return [self.sections count];
}

- (NSString *)sectionNameAtIndex:(NSInteger)section {

    return ((WOTTankDetailSection *)self.sections[section]).title;
}

- (NSArray *)metricsInSecton:(NSInteger)section {
    
    return ((WOTTankDetailSection *)self.sections[section]).metrics;
}

- (WOTTankDetailField *)metricAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *objects = [self metricsInSecton:indexPath.section];
    return objects[indexPath.row];
}

- (NSString *)queryAtSection:(NSInteger)section {
    
    return ((WOTTankDetailSection *)self.sections[section]).query;
}
@end
