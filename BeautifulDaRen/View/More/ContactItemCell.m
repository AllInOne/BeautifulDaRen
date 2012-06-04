//
//  ContactItemCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ContactItemCell.h"

@implementation ContactItemCell
@synthesize contactLabel = _contactLabel;
@synthesize contactImageView = _contactImageView;
@synthesize contactButton = _contactButton;

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

-(IBAction)buttonPressed:(id)sender
{
    NSLog(@"Contact pressed");
}

@end
