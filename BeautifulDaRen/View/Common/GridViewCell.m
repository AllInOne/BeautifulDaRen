//
//  FourGridViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "GridViewCell.h"

@implementation GridViewCell
@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourthLabel;
@synthesize fifthLabel;
@synthesize sixthLabel;

@synthesize firstButton;
@synthesize secondButton;
@synthesize thirdButton;
@synthesize fourthButton;
@synthesize fifthButton;
@synthesize sixthButton;

@synthesize secondBadgeView;

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

- (IBAction)buttonPressed:(UIButton*)sender
{
    [self.delegate didButtonPressed:sender inView:self];
}

@end
