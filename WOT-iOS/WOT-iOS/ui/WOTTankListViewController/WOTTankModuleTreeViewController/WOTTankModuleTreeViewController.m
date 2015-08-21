//
//  WOTTankModuleTreeViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankModuleTreeViewController.h"
#import "WOTTree+ModuleTree.h"
#import "WOTNode+ModuleTree.h"
#import "WOTNode+Enumeration.h"
#import "ModulesTree+UI.h"
#import "WOTTankConfigurationCollectionViewCell.h"
#import "WOTTankConfigurationFlowLayout.h"
#import "WOTTankConfigurationItemViewController.h"
#import "WYPopoverController.h"

#import "WOTTankConfigurationModuleMapping+Factory.h"

@interface WOTTankModuleTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) WOTTree *tree;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet WOTTankConfigurationFlowLayout *flowLayout;
@property (nonatomic, strong) WYPopoverController *wypopoverController;

@end

@implementation WOTTankModuleTreeViewController

- (void)dealloc {
    
    self.tree = nil;

    [self.wypopoverController dismissPopoverAnimated:YES];
    self.wypopoverController.delegate = nil;
    self.wypopoverController = nil;
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
    
    [self.flowLayout setDepthCallback:^(){
        
        return self.tree.levels;
    }];

    [self.flowLayout setWidthCallback:^(){
        
        return self.tree.endpointsCount;
    }];

    [self.flowLayout setLayoutPreviousSiblingNodeChildrenCountCallback:^(NSIndexPath *indexPath){

        WOTNode *node = [self.tree nodeAtIndexPath:indexPath];
        NSInteger result = node.childrenCountForSiblingNode;
        return result;
    }];

    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class])];
}

- (void)setTankId:(NSNumber *)value {

    _tankId = [value copy];
    [self.tree setTankId:value];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    WOTNode *node = [self.tree nodeAtIndexPath:indexPath];
    ModulesTree *moduleTree = [node moduleTree];
    
    WOTTankConfigurationItemViewController *itemViewController = [[WOTTankConfigurationItemViewController alloc] initWithNibName:NSStringFromClass([WOTTankConfigurationItemViewController class]) bundle:nil];
    itemViewController.moduleTree = moduleTree;
    itemViewController.mapping = [self mappingForModuleType:moduleTree.type];
    
    if (self.wypopoverController) {
        
        [self.wypopoverController dismissPopoverAnimated:YES];
        self.wypopoverController.delegate = nil;
        self.wypopoverController = nil;
    }
    
    self.wypopoverController = [[WYPopoverController alloc] initWithContentViewController:itemViewController];
    self.wypopoverController.delegate = nil;
    self.wypopoverController.dismissOnTap = YES;
    self.wypopoverController.theme.borderWidth = 2;
    self.wypopoverController.theme.innerCornerRadius = 0;
    self.wypopoverController.theme.outerCornerRadius = 0;
    self.wypopoverController.theme.outerStrokeColor = [UIColor lightGrayColor];
    self.wypopoverController.popoverContentSize = [[[UIApplication sharedApplication] keyWindow] bounds].size;
    [self.wypopoverController presentPopoverAsDialogAnimated:YES];
    
}


- (WOTTankConfigurationModuleMapping *)mappingForModuleType:(NSString *)moduleTypeStr {

    WOTTankConfigurationModuleMapping *result = nil;
    WOTModuleType moduleType = [ModulesTree moduleTypeFromString:moduleTypeStr];
    
    switch (moduleType) {
            
        case WOTModuleTypeEngine: {
            
            result = [WOTTankConfigurationModuleMapping engineMapping];
            break;
        }
        case WOTModuleTypeRadios: {
            
            result = [WOTTankConfigurationModuleMapping radiosMapping];
            break;
        }
        case WOTModuleTypeTurrets :{
            
            result = [WOTTankConfigurationModuleMapping turretMapping];
            break;
        }
            
        case WOTModuleTypeChassis: {
            
            result = [WOTTankConfigurationModuleMapping chassisMapping];
            break;
        }
        case WOTModuleTypeGuns: {
            
            result = [WOTTankConfigurationModuleMapping gunMapping];
            break;
        }
        default: {

            break;
        }
    }
    return result;
}

@end
