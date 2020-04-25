//
//  WOTTankConfigurationModuleMapping.h
//  WOT-iOS
//
//  Created on 7/20/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^WOTTankConfigurationModuleMappingExtractor)(id source);

@interface WOTTankConfigurationModuleMapping : NSObject

@property (nonatomic, copy) WOTTankConfigurationModuleMappingExtractor extractor;

- (void)addFields:(NSArray *)fields forSection:(NSString *)section;
- (NSArray *)fieldsForSection:(NSString *)section;
- (NSArray *)fieldsForSectionAtIndex:(NSInteger)sectionIndex;
- (NSString *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (id)fieldValueAtIndexPath:(NSIndexPath *)indexPath forObject:(id)object;

- (NSInteger)sectionsCount;
- (NSString *)sectionAtIndex:(NSInteger)index;

@end
