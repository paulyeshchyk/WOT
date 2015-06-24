//
//  WOTTankListSettingViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/12/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankListSettingViewController.h"
#import "WOTTankListSettingsDatasource.h"

@interface WOTTankListSettingViewController () <WOTTankListSettingsDatasourceListener>

@property (nonatomic, strong)UIBarButtonItem *backItem;
@property (nonatomic, strong)UIBarButtonItem *applyItem;

@end

@implementation WOTTankListSettingViewController

- (void)dealloc {
    
    [[WOTTankListSettingsDatasource sharedInstance] unregisterListener:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        self.setting = nil;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:WOTString(WOT_IMAGE_BACK)];
    self.backItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {

        if (self.cancelBlock){
            
            self.cancelBlock();
        }
        
    }];
    [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
    
    self.applyItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_APPLY) eventBlock:^(id sender) {

        if (self.applyBlock){
            
            self.applyBlock();
        }
        
    }];
    
    [[WOTTankListSettingsDatasource sharedInstance] registerListener:self];

    [self.navigationItem setRightBarButtonItems:[self backItemsArray]];
    [self.navigationController.navigationBar setDarkStyle];
    
}

- (NSArray *)backItemsArray {
    
    return @[self.applyItem];
}

- (void)setCanApply:(BOOL)canApply {
    
    _canApply = canApply;
    if (_canApply) {

        [self.navigationItem setRightBarButtonItems:[self backItemsArray]];
    } else {
        
        [self.navigationItem setRightBarButtonItems:nil];
    }
}


#pragma mark - WOTTankListSettingsDatasourceListener
- (void)willChangeContent {
    
}

- (void)didChangeContent {
    
}

- (void)didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
}

@end