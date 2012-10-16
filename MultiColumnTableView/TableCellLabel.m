//
//  TableCellLabel.m
//  MultiColumnTableView
//
//  Created by Ricky Gu on 2012-10-16.
//  Copyright (c) 2012 Newegg.com. All rights reserved.
//

#import "TableCellLabel.h"

@implementation TableCellLabel
@synthesize section, row, col;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
