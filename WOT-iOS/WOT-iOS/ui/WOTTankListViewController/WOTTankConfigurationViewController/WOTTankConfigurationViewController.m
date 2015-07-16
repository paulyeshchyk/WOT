//
//  WOTTankConfigurationViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationViewController.h"
#import "WOTTree+Tanks.h"
#import "WOTNode.h"
#import "WOTTankConfigurationCollectionViewCell.h"
#import "WOTTankConfigurationFlowLayout.h"

@interface WOTTankConfigurationViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)WOTTree *tree;
@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankConfigurationFlowLayout *flowLayout;

@end

@implementation WOTTankConfigurationViewController

- (void)dealloc {
    
    self.tree = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.tree = [[WOTTree alloc] init];
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *gearButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
    
    }];
    [self.navigationItem setRightBarButtonItems:@[gearButtonItem]];
    
    [self.flowLayout setDepthCallback:^(){
        
        NSInteger result = self.tree.levels;
        return result;
    }];

    [self.flowLayout setWidthCallback:^(){
        
        NSInteger result = self.tree.endpointsCount;
        return result;
    }];

    [self.flowLayout setLayoutPreviousSiblingNodeChildrenCountCallback:^(NSIndexPath *indexPath){

        WOTNode *node = [self.tree nodeAtIndexPath:indexPath];
        NSInteger result = [self.tree childrenCountForSiblingNode:node];
        return result;
    }];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class])];
}



- (void)setTankId:(NSNumber *)value {

    _tankId = [value copy];
    [self.tree setTankId:value];

    //#import "WOTTree+Test.h"
    //[self.tree setTestTankId:_tankId];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.tree.levels;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.tree nodesCountAtSection:section];
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTNode *node = [self.tree nodeAtIndexPath:indexPath];
    WOTTankConfigurationCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) forIndexPath:indexPath];
    result.indexPath = indexPath;
    result.label.text = node.name;
    [result.imageView sd_setImageWithURL:node.imageURL];
    
    
    return result;
}

@end
