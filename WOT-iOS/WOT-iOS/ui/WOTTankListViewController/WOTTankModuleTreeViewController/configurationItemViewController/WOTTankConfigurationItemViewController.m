//
//  WOTTankConfigurationItemViewController.m
//  WOT-iOS
//
//  Created by Paul on 7/20/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankConfigurationItemViewController.h"

#import "WOTTankConfigurationItemCell.h"
#import "WOTTankConfigurationItemHeaderFooter.h"
#import "ModulesTree+UI.h"

@interface WOTTankConfigurationItemViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UIImageView *imageView;
@property (nonatomic, weak)IBOutlet UILabel *titleLabel;
@property (nonatomic, weak)IBOutlet UITableView *tableView;

@end

@implementation WOTTankConfigurationItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankConfigurationItemCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankConfigurationItemHeaderFooter class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WOTTankConfigurationItemHeaderFooter class])];

    [self update];
}

- (void)setModuleTree:(ModulesTree *)moduleTree {
    
    if (_moduleTree != moduleTree) {
        
        _moduleTree = moduleTree;
        [self update];
    }
}

- (void)update {
    
    self.titleLabel.text = self.moduleTree.name;
    self.imageURL = [self.moduleTree localImageURL];
}

- (void)setImageURL:(NSURL *)imageURL {
    
    if (_imageURL != imageURL) {
        
        _imageURL = [imageURL copy];
        [self.imageView sd_setImageWithURL:_imageURL];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.mapping fieldsForSectionAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.mapping sectionsCount];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    WOTTankConfigurationItemHeaderFooter *result = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WOTTankConfigurationItemHeaderFooter class])];
    result.title = [self.mapping sectionAtIndex:section];
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WOTTankConfigurationItemCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankConfigurationItemCell class])];
    result.name = WOTString([self.mapping fieldAtIndexPath:indexPath]);
    result.value = [self.mapping fieldValueAtIndexPath:indexPath forObject:self.moduleTree];
    return result;
}

#pragma mark - UITableViewDelegate
@end
