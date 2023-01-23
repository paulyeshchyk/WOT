//
//  WOTLanguageSelectorViewController.m
//  WOT-iOS
//
//  Created on 6/4/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTLanguageSelectorViewController.h"
#import "WOTLanguageTableViewCell.h"
#import <WOTKit/WOTKit.h>
#import <WOTApi/WOTApi.h>

@interface WOTLanguageSelectorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@end

@implementation WOTLanguageSelectorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:[UIImage imageNamed:[NSString localization:WOTApiTexts.image_back]] text:nil eventBlock:^(id sender) {
        
        [self.delegate didSelectLanguage:nil appId:nil];
    }];

    [self.navigationItem setLeftBarButtonItems:@[backItem]];
    [self.navigationController.navigationBar setDarkStyle];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WOTLanguageTableViewCell" bundle:nil] forCellReuseIdentifier:@"WOTLanguageTableViewCell"];

}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[WOTLanguageDatasource sharedInstance] availableLanguages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTLanguageTableViewCell *cell = (WOTLanguageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WOTLanguageTableViewCell"];
    [cell.label setText:[[WOTLanguageDatasource sharedInstance] langAtIndex:indexPath.row]];
    [cell.imageView setImage:[[WOTLanguageDatasource sharedInstance] imageAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *lang = [[WOTLanguageDatasource sharedInstance] langAtIndex:indexPath.row];
    NSString *appId = [[WOTLanguageDatasource sharedInstance] appIdAtIndex:indexPath.row];
    
    [self.delegate didSelectLanguage:lang appId:appId];
}

@end
