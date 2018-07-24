//
//  WOTTankModuleTreeViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/29/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankModuleTreeViewController.h"
#import "ModulesTree+UI.h"
#import "WOTTankConfigurationCollectionViewCell.h"
#import "WOTTankConfigurationFlowLayout.h"
#import "WOTTankConfigurationItemViewController.h"
#import "WOTTankConfigurationModuleMapping+Factory.h"
#import "WOTEnums.h"

@interface WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)<WOTNodeCreatorProtocol>
@end

@implementation WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)

- (id<WOTNodeProtocol> _Nonnull)createNodeWithFetchedObject:(id<NSFetchRequestResult> _Nullable)fetchedObject byPredicate:(NSPredicate * _Nullable)byPredicate {
    if ([fetchedObject isKindOfClass: [Tanks class]]) {
        return [[WOTNodeSwift alloc] initWithName:((Tanks *)fetchedObject).name_i18n];
    } else if ([fetchedObject isKindOfClass: [ModulesTree class]]) {
        return [[WOTTreeModuleNode alloc] initWithModuleTree: fetchedObject];
    } else  {
        return [self createNodeWithName:@""];
    }
}

- (id<WOTNodeProtocol> _Nonnull)createNodeWithName:(NSString * _Nonnull)name {
   id<WOTNodeProtocol> result = [[WOTNodeSwift alloc] initWithName: name];
    result.isVisible = true;
    return result;
}

@end



@interface WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)<WOTDataFetchControllerDelegateProtocol>
@end

@implementation WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)
@dynamic fetchRequest;

- (NSFetchRequest *)fetchRequest {

    NSFetchRequest * result = [[NSFetchRequest alloc] initWithEntityName:@"Tanks"];
    result.sortDescriptors = [self sortDescriptors];
    result.predicate = [self fetchCustomPredicate];
    return result;
}

- (NSArray *) sortDescriptors {
    NSMutableArray *result = [[[WOTTankListSettingsDatasource sharedInstance] sortBy] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"tank_id" ascending:YES];
    [result addObject:descriptor];
    return result;
}

- (NSPredicate *) fetchCustomPredicate {

    NSPredicate *result = [NSPredicate predicateWithFormat:@"tank_id == %d", [self.tankId integerValue] ];
    return result;
}

@end

@interface WOTTankModuleTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WOTDataModelListener>

@property (nonatomic, strong) WOTTreeDataModel *model;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet WOTTankConfigurationFlowLayout *flowLayout;
@property (nonatomic, strong) id<WOTDataFetchControllerProtocol> fetchController;

@end

@implementation WOTTankModuleTreeViewController

- (void)dealloc {
    
    self.model = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){

        self.fetchController = [[WOTTankTreeFetchController alloc] initWithNodeFetchRequestCreator:self nodeCreator:self];
        self.model = [[WOTTreeDataModel alloc] initWithFetchController: self.fetchController listener: self];
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
        
        return self.model.levels;
    }];

    [self.flowLayout setWidthCallback:^(){
        
        return self.model.endpointsCount;
    }];

    [self.flowLayout setLayoutPreviousSiblingNodeChildrenCountCallback:^(NSIndexPath *indexPath){

        id<WOTNodeProtocol> node = [self.model nodeAtIndexPath:indexPath];
        NSInteger result = [WOTNodeEnumerator.sharedInstance childrenCountWithSiblingNode:node];
        return result;
    }];

    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class])];
}

- (void)setTankId:(NSNumber *)value {

    _tankId = [value copy];
    [self.model loadModel];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.model.levels;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.model nodesCountWithSection:section];
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<WOTNodeProtocol> node = [self.model nodeAtIndexPath:indexPath];
    WOTTankConfigurationCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankConfigurationCollectionViewCell class]) forIndexPath:indexPath];
    result.indexPath = indexPath;
    result.label.text = node.name;
    if ([node conformsToProtocol:@protocol(WOTTreeModuleNodeProtocol)]) {
        [result.imageView sd_setImageWithURL:((id<WOTTreeModuleNodeProtocol> )node).imageURL];
    }
    return result;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    id<WOTNodeProtocol> node = [self.model nodeAtIndexPath:indexPath];

    if ([node conformsToProtocol:@protocol(WOTTreeModuleNodeProtocol)]) {
        id<WOTTreeModuleNodeProtocol> treeNode = (id<WOTTreeModuleNodeProtocol>) node;
        ModulesTree *moduleTree = treeNode.modulesTree;

        WOTTankConfigurationItemViewController *itemViewController = [[WOTTankConfigurationItemViewController alloc] initWithNibName:NSStringFromClass([WOTTankConfigurationItemViewController class]) bundle:nil];
        itemViewController.moduleTree = moduleTree;
        itemViewController.mapping = [self mappingForModuleType:moduleTree.type];
        [self.navigationController pushViewController:itemViewController animated:YES];
    }
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

//WOTPivotDataModelListener
- (void)modelDidLoad {
    [self.collectionView reloadData];
}

- (void) modelDidFailLoadWithError:(NSError *)error {

}
- (NSArray *)metadataItems {
    return [[NSArray alloc] init];
}

@end
