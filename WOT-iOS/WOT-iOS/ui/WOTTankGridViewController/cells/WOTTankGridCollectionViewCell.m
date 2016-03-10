//
//  WOTTankGridCollectionViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 9/14/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankGridCollectionViewCell.h"
#import "WOTTankGridCollectionSubitemTableViewCell.h"
#import "WOTNode+DetailGrid.h"
#import "WOTTankEvalutionResult.h"

@interface WOTTankGridCollectionViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *metricNameLabel;
@property (nonatomic, weak) IBOutlet UITableView *subitemsTableView;

@end

@implementation WOTTankGridCollectionViewCell


+ (CGSize)sizeForSubitemsCount:(NSInteger)subitemsCount columnsCount:(NSInteger)columnsCount{
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(statusBarOrientation);
    
    CGFloat separatorWidth = 1.0f;
    CGFloat screenWidth = IS_IPAD?(isPortrait?768.0f:1024.0f):(isPortrait?320.0f:480.0f);
    
    CGFloat itemWidth = screenWidth/columnsCount-separatorWidth;
    
    CGFloat subitemHeight = 12.0f;
    CGFloat headerHeight = 21.0f;
    CGFloat headerTopPadding = 4.0f;
    CGFloat headerBottomPadding = 4.0f;
    CGFloat tableBottomPadding = 4.0f;
    CGFloat itemHeight = subitemHeight * subitemsCount + tableBottomPadding + (headerHeight + headerTopPadding + headerBottomPadding);
    
    return CGSizeMake(itemWidth,itemHeight);
}

- (void)dealloc {
    
    self.subitemsTableView.delegate = nil;
    self.subitemsTableView.dataSource = nil;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.subitemsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankGridCollectionSubitemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankGridCollectionSubitemTableViewCell class])];
}

- (void)setMetricName:(NSString *)metricName {
    
    _metricName = [metricName copy];
    self.metricNameLabel.text = _metricName;
}

- (void)setSubitems:(NSDictionary *)subitems {
    
    _subitems = [subitems copy];
}

- (void)reloadCell {
    
    [self.subitemsTableView reloadData];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.subitems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WOTTankGridCollectionSubitemTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankGridCollectionSubitemTableViewCell class]) forIndexPath:indexPath];

    WOTNode *node = self.subitems[indexPath.row];
    
    id key = node.name;
    WOTTankEvalutionResult *value = node.gridNodeData;
    
    result.captionText = key;
    result.valueText = [NSString stringWithFormat:@"%2.3f",value.thisValue];
    return result;
}
#pragma mark - UITableViewDelegate

@end
