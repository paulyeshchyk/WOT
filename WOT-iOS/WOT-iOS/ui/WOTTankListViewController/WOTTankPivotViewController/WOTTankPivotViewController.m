//
//  WOTTankPivotViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankPivotViewController.h"
#import "WOTTankPivotCollectionViewCell.h"
#import "WOTTankPivotLayout.h"

@interface WOTTankPivotViewController () <UICollectionViewDataSource>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankPivotLayout *flowLayout;

@end

@implementation WOTTankPivotViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *doneButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_APPLY) eventBlock:^(id sender) {
        
        if (self.doneBlock) {
            
            self.doneBlock(nil);
        }
    }];
    [self.navigationItem setRightBarButtonItems:@[doneButtonItem]];
    UIBarButtonItem *cancelButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_BACK) eventBlock:^(id sender) {
        
        if (self.cancelBlock) {
            
            self.cancelBlock();
        }
    }];
    [self.navigationItem setLeftBarButtonItems:@[cancelButtonItem]];
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankPivotCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotCollectionViewCell class])];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WOTTankPivotCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankPivotCollectionViewCell class]) forIndexPath:indexPath];
    result.label.text = @"lOrEm";
    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
