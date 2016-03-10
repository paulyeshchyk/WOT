//
//  WOTTankMetricProtocol.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/23/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOTTanksIDList.h"
#import "WOTTankEvalutionResult.h"

typedef WOTTankEvalutionResult*(^WOTTankMetricEvaluator)(WOTTanksIDList *tankID);

@protocol WOTTankMetricProtocol <NSObject>

@property (nonatomic, readonly) NSString *metricName;
@property (nonatomic, readonly) NSString *grouppingName;
@property (nonatomic, readonly) WOTTankMetricEvaluator evaluator;

@end