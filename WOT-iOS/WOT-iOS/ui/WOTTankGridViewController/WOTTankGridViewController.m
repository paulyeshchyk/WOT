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
    
    
    self.subitems = @[@{@"children":@{@"Lorem 1":@"1",@"Lorem 2":@"2"}, @"caption":@"Lorem"},
                      @{@"children":@{@"Lorem ips 1":@"1",@"\tLorem ips 2":@"3",@"\tLorem ips 3":@"3",@"\tLorem ips 4":@"4",@"\tLorem ips 11":@"11",@"Lorem ips 12":@"13",@"Lorem ips 13":@"13",@"Lorem ips 14":@"14"}, @"caption":@"Lorem ips"},
                      @{@"children":@{@"Lorem ips 101":@"101",@"Lorem ips 102":@"103",@"Lorem ips 103":@"103",@"Lorem ips 104":@"104",@"Lorem ips 1011":@"1011",@"Lorem ips 1012":@"1013",@"Lorem ips 1013":@"1013",@"Lorem ips 1014":@"1014"}, @"caption":@"Lorem ips"},
                      @{@"children":@{@"Lorem ips 201":@"201",@"Lorem ips 102":@"103",@"Lorem ips 103":@"103",@"Lorem ips 104":@"104",@"Lorem ips 2011":@"2011",@"Lorem ips 2012":@"2013",@"Lorem ips 2013":@"2013",@"Lorem ips 2014":@"2014"}, @"caption":@"Lorem ips"}
                      ];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankGridCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankGridCollectionViewCell class])];
}

- (NSInteger)columnsCount {
    
    return IS_IPAD?4.0f:2.0f;
}

- (void)orientationDidChanged:(id)notification {
    
    [self.collectionView.collectionViewLayout invalidateLayout];
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
