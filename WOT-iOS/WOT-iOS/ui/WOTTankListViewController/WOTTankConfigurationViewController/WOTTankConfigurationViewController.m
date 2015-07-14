//
//  WOTTankConfigurationViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationViewController.h"
#import "WOTTree.h"
#import "WOTNode.h"
#import "WOTTankConfigurationCollectionViewCell.h"
#import "WOTTankConfigurationFlowLayout.h"

@interface WOTTankConfigurationViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)WOTTree *tree;
@property (nonatomic, weak)IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)IBOutlet WOTTankConfigurationFlowLayout *flowLayout;

@end

@implementation WOTTankConfigurationViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.tree = [[WOTTree alloc] init];
    
    WOTNode *node0 = [[WOTNode alloc] initWithName:@"0 (level 0)" parent:nil];
    WOTNode *node00 = [[WOTNode alloc] initWithName:@"0.0 (level 1)" parent:node0];
    WOTNode *node01 = [[WOTNode alloc] initWithName:@"0.1 (level 1)" parent:node0];
    WOTNode *node02 = [[WOTNode alloc] initWithName:@"0.2 (level 1)" parent:node0];
    [node0 addChild:node00];
    [node0 addChild:node01];
    [node0 addChild:node02];

    WOTNode *node010 = [[WOTNode alloc] initWithName:@"0.1.0 (level 2)" parent:node01];
    WOTNode *node011 = [[WOTNode alloc] initWithName:@"0.1.1 (level 2)" parent:node01];
    WOTNode *node012 = [[WOTNode alloc] initWithName:@"0.1.2 (level 2)" parent:node01];
    WOTNode *node013 = [[WOTNode alloc] initWithName:@"0.1.3 (level 2)" parent:node01];
    [node01 addChild:node010];
    [node01 addChild:node011];
    [node01 addChild:node012];
    [node01 addChild:node013];

    WOTNode *node0110 = [[WOTNode alloc] initWithName:@"0.1.1.0 (level 3)" parent:node011];
    WOTNode *node0111 = [[WOTNode alloc] initWithName:@"0.1.1.1 (level 3)" parent:node011];
    [node011 addChild:node0110];
    [node011 addChild:node0111];

    WOTNode *node01110 = [[WOTNode alloc] initWithName:@"0.1.1.1.0 (level 4)" parent:node0111];
    WOTNode *node01111 = [[WOTNode alloc] initWithName:@"0.1.1.1.1 (level 4)" parent:node0111];
    [node0111 addChild:node01110];
    [node0111 addChild:node01111];

    WOTNode *node020 = [[WOTNode alloc] initWithName:@"0.2.0 (level 2)" parent:node02];
    WOTNode *node021 = [[WOTNode alloc] initWithName:@"0.2.1 (level 2)" parent:node02];
    
    [node02 addChild:node020];
    [node02 addChild:node021];
    
    WOTNode *node0210 = [[WOTNode alloc] initWithName:@"0.2.1.0 (level 3)" parent:node020];
    [node020 addChild:node0210];
    
    [self.tree addNode:node0];
    
    [self printSiblingIndexPath:[self.tree nodes][0] level:0];

    
    
//    debugLog(@"%@",node0210.siblingIndexPath);
    
    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_GEAR)];
    UIBarButtonItem *gearButtonItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {
    }];
    [self.navigationItem setRightBarButtonItems:@[gearButtonItem]];
    
    [self.flowLayout setDepth:^(){
        NSInteger result = self.tree.depth;
        return result;
    }];

    [self.flowLayout setWidth:^(){
        NSInteger result = self.tree.width;
        return result;
    }];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class])];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.tree.depth;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger result = [[self.tree nodesAtLevel:section] count];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankConfigurationCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) forIndexPath:indexPath];
    result.indexPath = indexPath;
    result.label.text = [self.tree nodeAtSiblingIndexPath:indexPath].name;
    
    
    return result;
}

- (void)printSiblingIndexPath:(WOTNode *)node  level:(NSInteger)level{

    debugLog(@"%@:%@",node.name, node.siblingIndexPath);
    [[node children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self printSiblingIndexPath:obj level:level+1];
    }];
}
@end
