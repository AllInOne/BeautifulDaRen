//
//  FourGridViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FourGridViewCell.h"

@implementation FourGridViewCell
@synthesize leftTopLabelName;
@synthesize leftTopLabelNumber;
@synthesize rightTopLabelName;
@synthesize rightTopLabelNumber;
@synthesize leftBottomLabelName;
@synthesize leftBottomLabelNumber;
@synthesize rightBottomLabelName;
@synthesize rightBottomLabelNumber;
@synthesize thirdLeftLabelName;
@synthesize thirdLeftLabelNumber;
@synthesize thirdRightLabelName;
@synthesize thirdRIghtLabelNumber;

@synthesize leftTopButton;
@synthesize leftButtomButton;
@synthesize rightTopButton;
@synthesize rightButtomButton;
@synthesize thirdLeftButton;
@synthesize thirdRightButton;

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

- (IBAction)buttonPressed:(id)sender
{
    NSAssert([sender isKindOfClass:[UIButton class]], @"sender is not a ");
    [self.delegate didButtonPressed:sender inView:self];
}

@end
