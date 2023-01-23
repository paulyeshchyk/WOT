//
//  WOTTankListSettingViewController.m
//  WOT-iOS
//
//  Created on 6/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankListSettingViewController.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>
#import "UIBarButtonItem+EventBlock.h"
#import "UIToolbar+WOT.h"
#import "UINavigationBar+WOT.h"

@interface WOTTankListSettingViewController () <WOTTankListSettingsDatasourceListener>

@property (nonatomic, strong)UIBarButtonItem *backItem;
@property (nonatomic, strong)UIBarButtonItem *applyItem;
@property (nonatomic, strong) WOTTankListSettingsDatasource *settingsDatasource;

@end

@implementation WOTTankListSettingViewController

- (void)dealloc {
    
    [_settingsDatasource unregisterListener:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
        _settingsDatasource = [[WOTTankListSettingsDatasource alloc] init];
        self.setting = nil;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    __weak typeof(self)weakSelf = self;
    UIImage *image = [UIImage imageNamed:[NSString localization:WOT_IMAGE_BACK]];
    self.backItem = [UIBarButtonItem barButtonItemForImage:image text:nil eventBlock:^(id sender) {

        if (weakSelf.cancelBlock){
            
            weakSelf.cancelBlock();
        }
        
    }];
    [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
    
    self.applyItem = [UIBarButtonItem barButtonItemForImage:nil text:[NSString localization:WOT_STRING_APPLY] eventBlock:^(id sender) {

        if (weakSelf.applyBlock){
            
            weakSelf.applyBlock();
        }
        
    }];
    
    [_settingsDatasource registerListener:self];

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
