//
//  GridCellView.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "GridCellView.h"

@implementation GridCellView

@synthesize cellImageView = _cellImageView;
@synthesize delegate = _delegate;
@synthesize cellObject = _cellObject;

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

- (IBAction)gridCellPressed:(UIButton*)sender
{
    [self.delegate didPressGridCell:self];
}
@end
