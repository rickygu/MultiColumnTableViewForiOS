/*
 * Copyright (c) 2011 Eli Wang
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */


#import "MultiColumnTableViewViewController.h"
#import "NSObject+DelayedBlock.h"

#define ROWS 100

@interface MultiColumnTableViewViewController()

- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@end





@implementation MultiColumnTableViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        srand(time(0));
    }
                 
    return self;
}


- (void)dealloc
{
    [data release];
    [tblView release];
    [sectionHeaderData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    numberOfColumns = 10;
    numberOfSections = 1;
    
    int sectionDistro[] = {30, 7, 4};
    colWidth = 92;
    
    data = [[NSMutableArray alloc] initWithCapacity:numberOfSections * 5];
    sectionHeaderData = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    
    for (int i = 0; i < numberOfSections; i++) {
        
        int rows = sectionDistro[i];
//        NSMutableArray *a = [NSMutableArray arrayWithCapacity:numberOfColumns];
//        for (int j = 0; j < numberOfColumns; j++) {
//            
//            int d = rand() % 100;
//            
//            NSMutableString *text = [NSMutableString stringWithFormat:@""];
//            if (d < 66) {
//                [text appendFormat:@"\nsecond line"];
//            }
//            
//            if (d < 33) {
//                [text appendFormat:@"\nthird line"];
//            }
//            
//            
//            [a addObject:text];
//        }
//        [sectionHeaderData addObject:a];

        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:10];
        for (int k = 0; k < rows; k++) {
            
            NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:numberOfColumns];
            for (int j = 0; j < numberOfColumns; j++) {
                int d = rand() % 100;
                
                NSMutableString *text = [NSMutableString stringWithFormat:@"clear"];
                
                [rowArray addObject:text];
            }
            
            [sectionArray addObject:rowArray];
        }
        
        [data addObject:sectionArray];
    }
    
    
    tblView = [[EWMultiColumnTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tblView.sectionHeaderEnabled = NO;
//    tblView.cellWidth = 100.0f;
//    tblView.boldSeperatorLineColor = [UIColor blueColor];
//    tblView.normalSeperatorLineColor = [UIColor blueColor];
//    tblView.boldSeperatorLineWidth = 10.0f;
//    tblView.normalSeperatorLineWidth = 10.0f;
    tblView.dataSource = self;
    tblView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tblView];
    
    [self performBlock:^{
            
        [tblView scrollToColumn:3 position:EWMultiColumnTableViewColumnPositionMiddle animated:YES];
    } afterDelay:0.5];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // e.g. self.myOutlet = nil;
    [tblView release];
    tblView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - EWMultiColumnTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfSections;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, colWidth, 40.0f)] autorelease];
    l.numberOfLines = 0;
    l.lineBreakMode = UILineBreakModeWordWrap;
    
    return l;
}


- (void)tableView:(EWMultiColumnTableView *)tableView setContentForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col{
    UILabel *l = (UILabel *)cell;
    
    NSString *text = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
    if ([text isEqualToString:@"1"]) {
        l.backgroundColor = [UIColor blueColor];
        NSLog(@"blue");
    }
    
    CGRect f = l.frame;
    f.size.width = [self tableView:tableView widthForColumn:col];
    l.frame = f;
    
    //trying to make a callback when cell is tapped, and change this cell's color here?
    l.userInteractionEnabled = YES;
    
    l.tag = col;
    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    recognizer.numberOfTapsRequired = 1;
    [l addGestureRecognizer:recognizer];
    
    
    //[l sizeToFit];
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    NSString *str = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
    CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
               constrainedToSize:CGSizeMake([self tableView:tableView widthForColumn:col], MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return s.height + 20.0f;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView widthForColumn:(NSInteger)column
{
    return colWidth;
}

- (NSInteger)tableView:(EWMultiColumnTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[data objectAtIndex:section] count];
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView sectionHeaderCellForSection:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self tableView:tableView widthForColumn:col], 40.0f)] autorelease];
    l.backgroundColor = [UIColor yellowColor];
    return l;
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForSectionHeaderCell:(UIView *)cell section:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@""];

    CGRect f = l.frame;
    f.size.width = [self tableView:tableView widthForColumn:col];
    l.frame = f;
    
    [l sizeToFit];
}

- (NSInteger)numberOfColumnsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfColumns;
}

#pragma mark Header Cell

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForIndexPath:(NSIndexPath *)indexPath
{
    return [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 92, 40.0f)] autorelease];
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCell:(UIView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Table %d", indexPath.row];
    
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForSectionHeaderCellAtSection:(NSInteger)section column:(NSInteger)col
{
    return 40.0f;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellInSectionHeaderForSection:(NSInteger)section
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self widthForHeaderCellOfTableView:tableView], 40.0f)] autorelease];
    l.backgroundColor = [UIColor orangeColor];
    return l;
    
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCellInSectionHeader:(UIView *)cell AtSection:(NSInteger)section
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Area %d", section];
    
}

- (CGFloat)widthForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 92;
}


- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForColumn:(NSInteger)col
{
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 92, 40.0f)] autorelease];
    l.text = [NSString stringWithFormat:@"%d:%d0", col/2+5, (col%2*3)];
    l.userInteractionEnabled = YES;
    
    l.tag = col;
//    UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)] autorelease];
//    recognizer.numberOfTapsRequired = 1;
//    [l addGestureRecognizer:recognizer];
    
    return l;
}

- (UIView *)topleftHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    UILabel *l =  [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 92, [self heightForHeaderCellOfTableView:tableView])] autorelease];
    l.text = @"Tables";
    
    return l;
}

- (CGFloat)heightForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 40.0f;
}

- (void)tableView:(EWMultiColumnTableView *)tableView swapDataOfColumn:(NSInteger)col1 andColumn:(NSInteger)col2
{
    for (int i = 0; i < [self numberOfSectionsInTableView:tableView]; i++) {
        NSMutableArray *section = [data objectAtIndex:i];
        for (int j = 0; j < [self tableView:tableView numberOfRowsInSection:i]; j++) {
            NSMutableArray *a = [section objectAtIndex:j];
            id tmp = [[a objectAtIndex:col2] retain];
            
            [a replaceObjectAtIndex:col2 withObject:[a objectAtIndex:col1]];
            [a replaceObjectAtIndex:col1 withObject:tmp];
            [tmp release];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    
    NSLog(@"change cell color here?");
    UILabel *cell = (UILabel*) recognizer.view;
    
    if (cell.backgroundColor == [UIColor redColor]) {
        cell.backgroundColor = [UIColor blueColor];
    }
    else if (cell.backgroundColor == [UIColor blueColor]){
        cell.backgroundColor = [UIColor clearColor];
    }
    else{
        cell.backgroundColor = [UIColor redColor];
    }
    
//    int col = [recognizer.view tag];
//    for (NSMutableArray *array in sectionHeaderData) {
//        [array removeObjectAtIndex:col];
////        [array addObject:@""];
//    }
//    
//    for (NSMutableArray *section in data) {
//        for (NSMutableArray *row in section) {
//            [row removeObjectAtIndex:col];
////            [row addObject:@""];
//        }
//    }
//    
//    numberOfColumns--;
//    
//    [tblView reloadData];

}

@end
