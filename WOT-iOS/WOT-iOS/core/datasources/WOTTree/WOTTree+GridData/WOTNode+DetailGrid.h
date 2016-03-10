//
//  WOTNode+DetailGrid.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/10/16.
//  Copyright © 2016 Pavel Yeshchyk. All rights reserved.
//

#import "WOTNode.h"

@interface WOTNode (DetailGrid)

- (id)initWithName:(NSString *)name gridData:(id)gridData;
- (void)setGridNodeData:(id)gridNodeData;
- (id)gridNodeData;

@end
