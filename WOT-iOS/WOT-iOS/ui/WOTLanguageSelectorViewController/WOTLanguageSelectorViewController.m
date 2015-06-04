//
//  WOTLanguageSelectorViewController.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/4/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTLanguageSelectorViewController.h"
#import "WOTLanguageDatasource.h"
#import "WOTLanguageTableViewCell.h"

@interface WOTLanguageSelectorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@end

@implementation WOTLanguageSelectorViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    UIBarButtonItem *backItem = [UIBarButtonItem barButtonItemForImage:nil text:WOTString(WOT_STRING_BACK) eventBlock:^(id sender) {
        
        [self.delegate didSelectLanguage:nil appId:nil];
    }];

    [self.navigationItem setLeftBarButtonItems:@[backItem]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WOTLanguageTableViewCell" bundle:nil] forCellReuseIdentifier:@"WOTLanguageTableViewCell"];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
