//
//  WOTTankPivotTemplate+Tanks.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/17/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTPivotTemplate+Tanks.h"

@implementation WOTPivotTemplate (Tanks)

- (void)makeTanksDefaultPivot {
    
    WOTPivotColumn *column = [[WOTPivotColumn alloc] initWithName:@"Type"];
    WOTPivotColumn *childColumn = [[WOTPivotColumn alloc] initWithName:@"SPG"];
    [column addChild:childColumn];
    childColumn = [[WOTPivotColumn alloc] initWithName:@"TD" predicate:nil];
    [column addChild:childColumn];
    childColumn = [[WOTPivotColumn alloc] initWithName:@"LT" predicate:nil];
    [column addChild:childColumn];
    childColumn = [[WOTPivotColumn alloc] initWithName:@"MT" predicate:nil];
    [column addChild:childColumn];
    childColumn = [[WOTPivotColumn alloc] initWithName:@"HT" predicate:nil];
    [column addChild:childColumn];
    [self addColumn:column];
    
    WOTPivotRow *row = [[WOTPivotRow alloc] initWithName:@"Tier"];
    WOTPivotRow *childrow = [[WOTPivotRow alloc] initWithName:@"I" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(1)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"II" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(2)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"III" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(3)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"IV" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(4)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"V" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(5)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"VI" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(6)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"VII" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(7)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"VIII" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(8)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"IX" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(9)]];
    [row addChild:childrow];
    childrow = [[WOTPivotRow alloc] initWithName:@"X" predicate:[NSPredicate predicateWithFormat:@"level == %@",@(10)]];
    [row addChild:childrow];
    [self addRow:row];
    
    
    
}

@end
