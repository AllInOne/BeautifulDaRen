//
//  AtMeViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/14/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "AtMeViewCell.h"

@implementation AtMeViewCell
@synthesize friendImageView;
@synthesize itemImageView;
@synthesize friendNameLabel;
@synthesize timeLabel;
@synthesize shopNameLabel;
@synthesize brandLabel;
@synthesize costLabel;
@synthesize descriptionView;

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

@end
