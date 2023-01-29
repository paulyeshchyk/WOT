//
//  WOTTankModuleTreeViewController.m
//  WOT-iOS
//
//  Created on 6/29/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankModuleTreeViewController.h"
#import "WOTTankTreeNodeCollectionViewCell.h"
#import "WOTTankConfigurationItemViewController.h"
#import "WOTTankConfigurationModuleMapping+Factory.h"
#import "UIBarButtonItem+EventBlock.h"
#import <WOT-Swift.h>
#import <WOTPivot/WOTPivot.h>
#import <WOTApi/WOTApi.h>
#import "UIImageView+WebCache.h"
#import <ContextSDK/ContextSDK-Swift.h>
#import "UIToolbar+WOT.h"
#import "UINavigationBar+WOT.h"
#import "NSBundle+LanguageBundle.h"


@interface WOTTankModuleTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NodeDataModelListener, MD5Protocol>

@property (nonatomic, strong) TreeDataModel *model;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet WOTTankConfigurationFlowLayout *flowLayout;
@property (nonatomic, strong) UIImageView *connectorsImageView;
@property (nonatomic, strong) WOTTankListSettingsDatasource *settingsDatasource;
@property (nonatomic, strong) WOTTankTreeFetchController *fetchController;

@end

@implementation WOTTankModuleTreeViewController
@synthesize appContext;
@synthesize MD5;

- (NSString *)MD5 {
    return [MD5 MD5From:@"WOTTankModuleTreeViewController"];
}

- (void)dealloc {
    [[self requestManager] removeListener: self];

    self.model = nil;
}

- (id<RequestManagerProtocol>) requestManager {
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return ((id<ContextProtocol>) delegate).requestManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){

        id<ContextProtocol> appDelegate = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];

        self.settingsDatasource = [[WOTTankListSettingsDatasource alloc] init];
        
        self.fetchController = [[WOTTankTreeFetchController alloc] initWithObjCFetchRequestContainer:self
                                                                                          appContext:appDelegate];
        self.model = [[TreeDataModel alloc] initWithFetchController: self.fetchController
                                                           listener: self
                                                        nodeCreator: self
                                                          nodeIndex: NodeIndex.self
                                                         appContext: appDelegate];
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    UIBarButtonItem *reloadButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:[NSString localization:WOT_STRING_RELOAD] eventBlock:^(id sender) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf reloadModel];
        }
    }];
    [self.navigationItem setRightBarButtonItems:@[reloadButtonItem]];
    
    
    UIBarButtonItem *cancelButtonItem = [UIBarButtonItem barButtonItemForImage:nil text:[NSString localization:WOT_STRING_BACK] eventBlock:^(id sender) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.cancelBlock) {
                strongSelf.cancelBlock();
            }
        }
    }];
    
    [self.navigationItem setLeftBarButtonItems:@[cancelButtonItem]];
    [self.navigationController.navigationBar setDarkStyle];

    [self.flowLayout setDepthCallback:^NSInteger {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            return strongSelf.model.levels;
        } else {
            return 0;
        }
    }];
    
    [self.flowLayout setWidthCallback:^NSInteger{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            return strongSelf.model.endpointsCount;
        } else {
            return 0;
        }
    }];

    NodeEnumerator *enumerator = [[NodeEnumerator alloc] init];
    [self.flowLayout setLayoutPreviousSiblingNodeChildrenCountCallback:^NSInteger(NSIndexPath * _Nonnull indexPath) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            id<NodeProtocol> node = [strongSelf.model nodeAtIndexPath: indexPath];
            NSInteger result = [enumerator childrenCountWithSiblingNode:node];
            return result;
        } else {
            return 0;
        }
    }];


    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankTreeConnectorCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeConnectorCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class])];

//    [self reloadModel];
}

- (void)reloadModel {
    //TODO: "To be checked"
    if (![[NSThread currentThread] isMainThread]) {
        NSAssert(NO, @"Thread should be main");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( [self isViewLoaded] ){
            [self.model loadModel];
        }
    });
}

- (void)setTank_Id:(NSNumber *)value {

    _tank_Id = [value copy];
    id<ContextProtocol> appContext = (id<ContextProtocol>)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [WOTWEBRequestFactory fetchVehicleTreeDataWithVehicleId: [_tank_Id integerValue]
                                                 appContext: appContext
                                                 completion:^(id<UOWResultProtocol> _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadModel];
        });
    }];
  }

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.model.levels;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger result = [self.model nodesCountWithSection:section];
    return result;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<NodeProtocol> node = [self.model nodeAtIndexPath:indexPath];
    WOTTankTreeNodeCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class]) forIndexPath:indexPath];
    result.indexPath = indexPath;
    result.label.text = node.name;
    if ([node conformsToProtocol:@protocol(WOTTreeModuleNodeProtocol)]) {
        [result.imageView sd_setImageWithURL:((id<WOTTreeModuleNodeProtocol> )node).imageURL];
    }
    return result;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    id<NodeProtocol> node = [self.model nodeAtIndexPath:indexPath];

    if ([node conformsToProtocol:@protocol(WOTTreeModuleNodeProtocol)]) {
        id<WOTTreeModuleNodeProtocol> treeNode = (id<WOTTreeModuleNodeProtocol>) node;
        id<WOTTreeModulesTreeProtocol> moduleTree = treeNode.modulesTree;

        WOTTankConfigurationItemViewController *itemViewController = [[WOTTankConfigurationItemViewController alloc] initWithNibName:NSStringFromClass([WOTTankConfigurationItemViewController class]) bundle:nil];
        itemViewController.moduleTree = moduleTree;
        itemViewController.mapping = [self mappingForModuleType:moduleTree.moduleType];
        [self.navigationController pushViewController:itemViewController animated:YES];
    }
}

- (WOTTankConfigurationModuleMapping *)mappingForModuleType:(NSString *)moduleTypeStr {

    WOTTankConfigurationModuleMapping *result = nil;
    ObjCVehicleModuleType moduleType = [ObjCVehicleModuleTypeConverter fromString: moduleTypeStr];
    
    switch (moduleType) {
            
        case ObjCModuleTypeEngine: {
            
            result = [WOTTankConfigurationModuleMapping engineMapping];
            break;
        }
        case ObjCModuleTypeRadios: {
            
            result = [WOTTankConfigurationModuleMapping radiosMapping];
            break;
        }
        case ObjCModuleTypeTurrets :{
            
            result = [WOTTankConfigurationModuleMapping turretMapping];
            break;
        }
            
        case ObjCModuleTypeChassis: {
            
            result = [WOTTankConfigurationModuleMapping chassisMapping];
            break;
        }
        case ObjCModuleTypeGuns: {
            
            result = [WOTTankConfigurationModuleMapping gunMapping];
            break;
        }
        default: {

            break;
        }
    }
    return result;
}

#pragma mark -

- (void) didFinishLoadModelWithError:(NSError *)error {
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{

        [self addConnectorsLayer];
    });
}

//-------
- (void)addConnectorsLayer {
    [self.connectorsImageView removeFromSuperview];
    
    UIImage *img = [WOTTankModuleTreeNodeConnectorLayer connectorsForModel:self.model byFrame:self.collectionView.frame flowLayout:self.flowLayout];
    self.connectorsImageView = [[UIImageView alloc] initWithImage:img];
    [self.collectionView addSubview: self.connectorsImageView];
}

@end

@interface WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)<NodeCreatorProtocol>
@property (nonatomic, weak) id<RequestManagerProtocol> requestManager;
@end

@implementation WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)
@dynamic collapseToGroups;
@dynamic requestManager;
@dynamic useEmptyNode;

- (id<NodeProtocol> _Nonnull)createNodeWithFetchedObject:(id<NSFetchRequestResult> _Nullable)fetchedObject byPredicate:(NSPredicate * _Nullable)byPredicate {
    if ([fetchedObject isKindOfClass: [Vehicles class]]) {
#warning("add WOTTankNode")
        return [[Node alloc] initWithName:((Vehicles *)fetchedObject).name];
    } else if ([fetchedObject isKindOfClass: [ModulesTree class]]) {
        return [[WOTTreeModuleNode alloc] initWithModuleTree:(ModulesTree *)fetchedObject];
    } else  {
        return [self createNodeWithName:@""];
    }
}

- (id<NodeProtocol> _Nonnull)createNodeWithName:(NSString * _Nonnull)name {
   return [[Node alloc] initWithName: name];
}

- (id<NodeProtocol> _Nonnull)createEmptyNode {
    NSAssert(NO, @"has not been implemented yet");
    return [[Node alloc] initWithName: @""];
}

- (id<NodeProtocol> _Nonnull)createNodeGroupWithName:(NSString * _Nonnull)name fetchedObjects:(NSArray * _Nonnull)fetchedObjects byPredicate:(NSPredicate * _Nullable)byPredicate {
    NSAssert(NO, @"has not been implemented yet");
    return [[Node alloc] initWithName: @""];
}

- (NSArray<id<NodeProtocol>> * _Nonnull)createNodesWithFetchedObjects:(NSArray * _Nonnull)fetchedObjects byPredicate:(NSPredicate * _Nullable)byPredicate {
    NSAssert(NO, @"has not been implemented yet");
    return @[[[Node alloc] initWithName: @""]];
}

@end

@interface WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)<FetchRequestContainerProtocol>
@end

@implementation WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)
@dynamic fetchRequest;

- (NSFetchRequest *)fetchRequest {

    NSFetchRequest * result = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
    result.sortDescriptors = [self sortDescriptors];
    result.predicate = [self fetchCustomPredicate];
    result.includesSubentities = true;
    result.includesPendingChanges = true;
    return result;
}

- (NSArray *) sortDescriptors {
    NSMutableArray *result = [[self.settingsDatasource sortBy] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:WOTApiFields.tank_id ascending:YES];
    [result addObject:descriptor];
    return result;
}

- (NSPredicate *) fetchCustomPredicate {
    return [NSPredicate predicateWithFormat:@"%K == %@", WOTApiFields.tank_id, self.tank_Id ];
}

@end


@implementation DeinitRequestCancelReason

@synthesize error;
@synthesize reasonDescription;

- (NSString *)reasonDescription {
    return  @"deinit";
}

@end
