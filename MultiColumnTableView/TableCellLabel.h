//
//  TableCellLabel.h
//  MultiColumnTableView
//
//  Created by Ricky Gu on 2012-10-16.
//  Copyright (c) 2012 Newegg.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCellLabel : UILabel{
    NSUInteger section;
    NSUInteger row;
    NSUInteger col;
}
@property (nonatomic) NSUInteger section;
@property (nonatomic) NSUInteger row;
@property (nonatomic) NSUInteger col;

@end
