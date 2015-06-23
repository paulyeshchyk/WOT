//
//  WOTTankDetailDatasource.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/22/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailDatasource.h"

@interface WOTTankDetailDatasource ()

@property (nonatomic, strong)NSDictionary *fields;

@end

@implementation WOTTankDetailDatasource


- (id)init {
    
    self = [super init];
    if (self){
        
        NSDictionary *enginesSection = @{@"metrics":@[[WOTTankDetailField fieldWithFieldPath:WOT_KEY_NAME_I18N],
                                                      [WOTTankDetailField fieldWithFieldPath:WOT_KEY_POWER],
                                                      [WOTTankDetailField fieldWithFieldPath:WOT_KEY_PRICE_CREDIT],
                                                      [WOTTankDetailField fieldWithFieldPath:WOT_KEY_FIRE_STARTING_CHANCE]
                                                      ],
                                         @"query": WOT_LINKKEY_ENGINES
                                   };
        NSDictionary *chassisSection = @{@"metrics":@[[WOTTankDetailField fieldWithFieldPath:WOT_KEY_NAME_I18N],
                                                      [WOTTankDetailField fieldWithFieldPath:WOT_KEY_PRICE_CREDIT],
                                                      [WOTTankDetailField fieldWithFieldPath:WOT_KEY_ROTATION_SPEED]
                                                      ],
                                         @"query": WOT_LINKKEY_SUSPENSIONS
                                         };
        self.fields = @{@"engines":enginesSection,@"chassis":chassisSection};
        
    }
    return self;
}

+ (WOTTankDetailField *)fieldWithFieldPath:(NSString *)fieldPath sectionName:(NSString *)sectionName {
 
    return nil;
}

- (NSInteger)numberOfSections {
    
    NSInteger result = [[self.fields allKeys] count];
    return result;
}

- (NSString *)sectionNameAtIndex:(NSInteger)section {

    return [self.fields allKeys][section];
}

- (NSArray *)fieldsInSecton:(NSInteger)section {
    
    id key = [self.fields allKeys][section];
    return self.fields[key][@"metrics"];
}

- (WOTTankDetailField *)fieldAtIndexPath:(NSIndexPath *)indexPath {

    id key = [self.fields allKeys][indexPath.section];
    NSArray *objects = self.fields[key][@"metrics"];
    
    return objects[indexPath.row];
}

- (NSString *)queryAtSection:(NSInteger)section {
    
    id key = [self.fields allKeys][section];
    return self.fields[key][@"query"];
}
@end
