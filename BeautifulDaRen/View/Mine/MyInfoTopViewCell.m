//
//  MyInfoTopViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MyInfoTopViewCell.h"

@implementation MyInfoTopViewCell
@synthesize avatarImageView;
@synthesize levelImageView;
@synthesize leftImageView;
@synthesize beautifulIdLabel;
@synthesize cityLabel;
@synthesize levelLabel;

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
}

@end
