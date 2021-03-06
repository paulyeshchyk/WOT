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
#import "WOTTankListSettingsDatasource.h"
#import <WOT-Swift.h>
#import <WOTPivot/WOTPivot.h>
#import "UINavigationBar+WOT.h"
#import "UIImageView+WebCache.h"
#import "UIBarButtonItem+EventBlock.h"

@interface WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)<WOTNodeCreatorProtocol>
@property (nonatomic, strong) id<WOTRequestManagerProtocol> requestManager;
@property (nonatomic, strong) id<WOTHostConfigurationProtocol> hostConfiguration;
@end

@implementation WOTTankModuleTreeViewController(WOTNodeCreatorProtocol)
@dynamic collapseToGroups;
@dynamic hostConfiguration;
@dynamic requestManager;
@dynamic useEmptyNode;

- (id<WOTNodeProtocol> _Nonnull)createNodeWithFetchedObject:(id<NSFetchRequestResult> _Nullable)fetchedObject byPredicate:(NSPredicate * _Nullable)byPredicate {
    if ([fetchedObject isKindOfClass: [Vehicles class]]) {
#warning("add WOTTankNode")
        return [[WOTNode alloc] initWithName:((Vehicles *)fetchedObject).name];
    } else if ([fetchedObject isKindOfClass: [ModulesTree class]]) {
        return [[WOTTreeModuleNode alloc] initWithModuleTree:(ModulesTree *)fetchedObject];
    } else  {
        return [self createNodeWithName:@""];
    }
}

- (id<WOTNodeProtocol> _Nonnull)createNodeWithName:(NSString * _Nonnull)name {
   return [[WOTNode alloc] initWithName: name];
}

- (id<WOTNodeProtocol> _Nonnull)createEmptyNode {
    NSAssert(NO, @"not overriden yet");
    return [[WOTNode alloc] initWithName: @""];
}


- (id<WOTNodeProtocol> _Nonnull)createNodeGroupWithName:(NSString * _Nonnull)name fetchedObjects:(NSArray * _Nonnull)fetchedObjects byPredicate:(NSPredicate * _Nullable)byPredicate {
    NSAssert(NO, @"not overriden yet");
    return [[WOTNode alloc] initWithName: @""];
}


- (NSArray<id<WOTNodeProtocol>> * _Nonnull)createNodesWithFetchedObjects:(NSArray * _Nonnull)fetchedObjects byPredicate:(NSPredicate * _Nullable)byPredicate {
    NSAssert(NO, @"not overriden yet");
    return @[[[WOTNode alloc] initWithName: @""]];
}


@end

@interface WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)<WOTDataFetchControllerDelegateProtocol>
@end

@implementation WOTTankModuleTreeViewController(WOTDataFetchControllerDelegateProtocol)
@dynamic fetchRequest;

- (NSFetchRequest *)fetchRequest {

    NSFetchRequest * result = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Vehicles class])];
    result.sortDescriptors = [self sortDescriptors];
    result.predicate = [self fetchCustomPredicate];
    return result;
}

- (NSArray *) sortDescriptors {
    NSMutableArray *result = [[self.settingsDatasource sortBy] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:WOTApiKeys.tank_id ascending:YES];
    [result addObject:descriptor];
    return result;
}

- (NSPredicate *) fetchCustomPredicate {

    return [NSPredicate predicateWithFormat:@"%K == %@", WOTApiKeys.tank_id, self.tank_Id ];
}

@end

@interface WOTTankModuleTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WOTRequestListenerProtocol, WOTRequestManagerListenerProtocol, WOTDataModelListener>

@property (nonatomic, strong) WOTTreeDataModel *model;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet WOTTankConfigurationFlowLayout *flowLayout;
@property (nonatomic, strong) WOTTankTreeFetchController *fetchController;
@property (nonatomic, strong) UIImageView *connectorsImageView;

@end

@implementation WOTTankModuleTreeViewController
@synthesize uuidHash;
@synthesize appManager;

- (void)dealloc {
    
    self.model = nil;
}

- (id<WOTHostConfigurationProtocol>) hostConfiguration {
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        return ((id<WOTAppDelegateProtocol>) delegate).appManager.hostConfiguration;
}

- (id<WOTRequestManagerProtocol>) requestManager {
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    return ((id<WOTAppDelegateProtocol>) delegate).appManager.requestManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        id<WOTAppDelegateProtocol> appDelegate = (id<WOTAppDelegateProtocol>)[[UIApplication sharedApplication] delegate];
        id<WOTCoredataStoreProtocol> coreDataProvider = appDelegate.appManager.coreDataStore;

        self.settingsDatasource = [[WOTTankListSettingsDatasource alloc] init];
        
        self.fetchController = [[WOTTankTreeFetchController alloc] initWithNodeFetchRequestCreator:self
                                                                                      dataprovider:coreDataProvider];
        self.model = [[WOTTreeDataModel alloc] initWithFetchController: self.fetchController
                                                              listener: self
                                                            enumerator: [WOTNodeEnumerator sharedInstance]
                                                           nodeCreator: self];
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


    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankTreeConnectorCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeConnectorCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class])];

//    [self reloadModel];
}

- (void)reloadModel {
    if ( [self isViewLoaded] ){

        [self.model loadModel];
    }
}

- (void)setTank_Id:(NSNumber *)value {

    _tank_Id = [value copy];

    NSError *error = nil;
    [WOTWEBRequestFactory fetchVehicleTreeDataWithVehicleId: [_tank_Id integerValue]
                                             requestManager: self.requestManager
                                                   listener: self
                                                      error: &error];
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
    WOTTankTreeNodeCollectionViewCell *result = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WOTTankTreeNodeCollectionViewCell class]) forIndexPath:indexPath];
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

//WOTRequestListenerProtocol

- (void)requestHasStarted:(id<WOTRequestProtocol>)request pumper: (NSObject *) pumper{
    
}

- (void)request:(id)request finishedLoadData:(NSData *)data error:(NSError *)error {
    [self reloadModel];
}

- (void)request:(id<WOTRequestProtocol> _Nonnull)request canceledWith:(NSError * _Nullable)error {
    
}


- (void)request:(id<WOTRequestProtocol> _Nonnull)request startedWith:(id<WOTHostConfigurationProtocol> _Nonnull)hostConfiguration args:(id<WOTRequestArgumentsProtocol> _Nonnull)args {
    
}


- (void)requestHasCanceled:(id<WOTRequestProtocol>)request {
    
}

- (void)removeRequest:(id<WOTRequestProtocol> _Nonnull)request {
    
}


- (void)requestHasStarted:(id<WOTRequestProtocol> _Nonnull)request {
    
}


- (NSInteger)uuidHash {
    return [@"WOTTankModuleTreeViewController" hash];
}

- (void)requestManager:(id<WOTRequestManagerProtocol> _Nonnull)requestManager didParseDataForRequest:(id<WOTRequestProtocol> _Nonnull)didParseDataForRequest completionResultType:(enum WOTRequestManagerCompletionResultType)completionResultType error:(NSError * _Nullable)error {
    
    if (completionResultType == WOTRequestManagerCompletionResultTypeFinished ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadModel];
        });
    }
}

- (void)requestManager:(id<WOTRequestManagerProtocol> _Nonnull)requestManager didStartRequest:(id<WOTRequestProtocol> _Nonnull)didStartRequest {
    //
}

- (void)modelDidLoad {
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self addConnectorsLayer];
    });
}

- (void) modelDidFailLoadWithError:(NSError *)error {
    
}

- (NSArray *)metadataItems {
    return [[NSArray alloc] init];
}

//-------
- (void)addConnectorsLayer {
    [self.connectorsImageView removeFromSuperview];
    
    UIImage *img = [WOTTankModuleTreeNodeConnectorLayer connectorsForModel:self.model byFrame:self.collectionView.frame flowLayout:self.flowLayout];
    self.connectorsImageView = [[UIImageView alloc] initWithImage:img];
    [self.collectionView addSubview: self.connectorsImageView];
}

@end
