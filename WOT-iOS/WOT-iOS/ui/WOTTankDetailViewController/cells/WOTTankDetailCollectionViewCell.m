//
//  WOTTankDetailCollectionViewCell.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/19/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTTankDetailCollectionViewCell.h"
#import "WOTTankDetailTableViewCell.h"
#import "WOTTankDetailField.h"

static const NSInteger RowHeight = 22.0f;

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

    self.isLastInSection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WOTTankDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WOTTankDetailTableViewCell class])];
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

    WOTTankDetailTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WOTTankDetailTableViewCell class]) forIndexPath:indexPath];

    WOTTankDetailField *field = self.fields[indexPath.row];
    result.nameLabel.text = WOTString(field.fieldDescriotion?field.fieldDescriotion:field.fieldPath);

    id value = [field evaluateWithObject:self.fetchedObject];
    result.valueLabel.text = [value description];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return RowHeight;
}

- (void)invalidate {
    
    self.bottomSeparatorView.backgroundColor = self.isLastInSection?[UIColor clearColor]:WOT_COLOR_BOTTOM_CELL_SEPARATOR;
    
    [self.tableView reloadData];
}

@end
