//
//  ContactItemCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendItemCell.h"

@implementation FriendItemCell
@synthesize friendNameLabel = _friendNameLabel;
@synthesize friendImageView = _friendImageView;
@synthesize actionButton = _actionButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(IBAction)buttonPressed:(id)sender
{
    NSLog(@"Contact pressed");
}

@end
