//
//  ButtonWithIconViewCell.m
//
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ButtonViewCell.h"

@implementation ButtonViewCell
@synthesize buttonRightIcon;
@synthesize buttonLeftIcon;
@synthesize buttonText;
@synthesize buttonRightText;
@synthesize leftLabel;
@synthesize leftButton;
@synthesize rightButton;
@synthesize segmentedControl;
@synthesize buttonLeftIconPressed;
@synthesize badgeView;

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
    if (selected && buttonLeftIconPressed) {
        self.buttonLeftIcon.image = buttonLeftIconPressed;
    }

}

-(IBAction)buttonPressed:(UIButton*)sender
{
    [self.delegate didButtonPressed:sender inView:self];
}

@end
