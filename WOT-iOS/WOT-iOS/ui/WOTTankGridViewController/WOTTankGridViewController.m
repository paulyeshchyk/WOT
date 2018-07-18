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

@property (nonatomic, strong)WOTTreeSwift *subitemsTree;

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

- (void)reload {
    
    self.subitemsTree = [self.delegate gridData];
    
    [self.collectionView reloadData];
}

- (void)needToBeCleared {

    self.subitemsTree = nil;
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
    
    return [[self.subitemsTree rootNodes] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    WOTTankGridCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankGridCollectionViewCell class]) forIndexPath:indexPath];
    //TODO: remove comment
//    WOTNode *rootNode = [[self.subitemsTree rootNodes] allObjects][indexPath.row];
//    result.metricName = rootNode.name;
//    result.subitems = rootNode.children;
    [result reloadCell];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger maxValue = 0;
    for (id rootNode in self.subitemsTree.rootNodes) {
        
        maxValue = MAX(maxValue, [[rootNode children] count]);
    }
    return [WOTTankGridCollectionViewCell sizeForSubitemsCount:maxValue columnsCount:self.columnsCount];
}
@end
