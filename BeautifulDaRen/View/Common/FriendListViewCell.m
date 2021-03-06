//
//  FriendListViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendListViewCell.h"

@implementation FriendListViewCell
@synthesize friendNameLabel;
@synthesize avatarImageView;
@synthesize actionButton;
@synthesize delegate;
@synthesize buyStatusView;
@synthesize vMarkImageView;
@synthesize buyStatusLabel;
@synthesize cancelBuyButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)buttonClicked:(UIButton*)sender
{
    [self.delegate didButtonPressed:sender inView:self];
}
@end
