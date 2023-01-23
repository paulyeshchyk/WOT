//
//  WOTTankDetailCollectionViewCell.m
//  WOT-iOS
//
//  Created on 6/19/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "WOTTankDetailCollectionViewCell.h"
#import "WOTTankDetailTextTableViewCell.h"
#import "WOTTankDetailProgressTableViewCell.h"
#import "WOTTankDetailField.h"

static const NSInteger RowHeight = 44.0f;

@interface WOTTankDetailCollectionViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, weak)IBOutlet UIView *bottomSeparatorView;

@end

@implementation WOTTankDetailCollectionViewCell

+ (CGSize)sizeFitSize:(CGSize)size forFetchedObject:(id)fetchedObject andFields:(NSArray *)fields {
    
    return CGSizeMake(size.width, RowHeight*fields.count);
}

- (void)dealloc {
    
    self.fetchedObject = nil;
}

- (void)awakeFromNib {

    [super awakeFromNib];

    self.fetchedObject = nil;

    self.isLastInSection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailTextTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankDetailTextTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailProgressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankDetailProgressTableViewCell class])];
    [self.tableView setEstimatedRowHeight:RowHeight];
}

- (void)setHighlighted:(BOOL)highlighted {

    [super setHighlighted:NO];
    [self setNeedsDisplay];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WOTTankDetailField *field = self.fields[indexPath.row];
    UITableViewCell<WOTTankDetailTableViewCellProtocol> *result = nil;
    
    if ([field isKindOfClass:[NSClassFromString(@"WOTTankDetailFieldExpression") class]] ) {
    
        result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankDetailProgressTableViewCell class]) forIndexPath:indexPath];
    } else {
        
        result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankDetailTextTableViewCell class]) forIndexPath:indexPath];
    }
    [result parseObject:self.fetchedObject withField:field];
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return RowHeight;
}

- (void)invalidate {
    
    self.bottomSeparatorView.backgroundColor = self.isLastInSection ? [UIColor clearColor] : WOT_COLOR_BOTTOM_CELL_SEPARATOR;
    
    [self.tableView reloadData];
}

@end
