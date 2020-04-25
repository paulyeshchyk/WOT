//
//  WOTTankConfigurationModuleMapping.m
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankConfigurationModuleMapping.h"

@interface WOTTankConfigurationModuleMapping()

@property (nonatomic, strong)NSMutableDictionary *sections;

@end

@implementation WOTTankConfigurationModuleMapping

- (void)addFields:(NSArray *)fields forSection:(NSString *)section {
    
    if (!self.sections){
        
        self.sections = [[NSMutableDictionary alloc] init];
    }
    [self.sections setObject:fields forKey:section];
}

- (NSArray *)fieldsForSection:(NSString *)section {
    
    return self.sections[section];
}

- (NSArray *)fieldsForSectionAtIndex:(NSInteger)sectionIndex {
    
    id section = [self sectionAtIndex:sectionIndex];
    return [self fieldsForSection:section];
}

- (NSInteger)sectionsCount {
    
    return [[self.sections allKeys] count];
}

- (NSString *)sectionAtIndex:(NSInteger)index {
    
    return [self.sections allKeys][index];
}

- (NSString *)fieldAtIndexPath:(NSIndexPath *)indexPath {
    
    id section = [self sectionAtIndex:indexPath.section];
    return [self fieldsForSection:section][indexPath.row];
}

- (id)fieldValueAtIndexPath:(NSIndexPath *)indexPath forObject:(id)object {

    if (!self.extractor) {
        
        return nil;
    }
    
    id field = [self fieldAtIndexPath:indexPath];
    id extractedObj = self.extractor(object);
    return [extractedObj valueForKeyPath:field];
    
}

@end
