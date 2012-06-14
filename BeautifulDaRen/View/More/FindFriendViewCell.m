//
//  FindFriendViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/23/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindFriendViewCell.h"

@implementation FindFriendViewCell
@synthesize avatarImageView;
@synthesize nameLabel;
@synthesize levelLabel;
@synthesize followButton;
@synthesize delegate;


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

-(IBAction)onButtonClicked:(UIButton*)sender
{
    [self.delegate didButtonPressed:sender inView:self];
}

@end
