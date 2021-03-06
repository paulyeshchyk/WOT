//
//  WOTTankDetailCollectionViewCell.h
//  WOT-iOS
//
//  Created on 6/19/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOTTankDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)NSManagedObject *fetchedObject;
@property (nonatomic, copy) NSArray *fields;
@property (nonatomic, assign)BOOL isLastInSection;

+ (CGSize)sizeFitSize:(CGSize)size forFetchedObject:(id)fetchedObject andFields:(NSArray *)fields;
- (void)invalidate;

@end
