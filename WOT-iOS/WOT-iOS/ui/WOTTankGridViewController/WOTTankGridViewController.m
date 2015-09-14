//
//  WOTTankGridViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankGridViewController.h"
#import "WOTTankGridCollectionViewCell.h"

@interface WOTTankGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSArray *subitems;

@property (nonatomic, readonly) NSInteger columnsCount;

@end

@implementation WOTTankGridViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankGridCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankGridCollectionViewCell class])];
}

#warning crash  occurs after third time ui changed
- (void)reload {
    
    self.subitems = [self.delegate gridData];
    [self.collectionView reloadData];
}

- (void)needToBeCleared {

    self.subitems = nil;
}

- (NSInteger)columnsCount {
    
    return IS_IPAD?4.0f:2.0f;
}

#pragma mark - Notifications
- (void)orientationDidChanged:(id)notification {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    [flowLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.subitems count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *subitem = self.subitems[indexPath.row];
    
    WOTTankGridCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankGridCollectionViewCell class]) forIndexPath:indexPath];
    result.metricName = subitem[@"caption"];
    result.subitems = subitem[@"children"];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger maxValue = 0;
    for (id subItem in self.subitems) {
        
        maxValue = MAX(maxValue, [[subItem valueForKeyPath:@"children.@count"] integerValue]);
    }
    return [WOTTankGridCollectionViewCell sizeForSubitemsCount:maxValue columnsCount:self.columnsCount];
}
@end
