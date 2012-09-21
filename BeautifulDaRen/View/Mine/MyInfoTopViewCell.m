//
//  MyInfoTopViewCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MyInfoTopViewCell.h"

@implementation MyInfoTopViewCell
@synthesize avatarImageView = _avatarImageView;
@synthesize levelLabel = _levelLabel;
@synthesize rightImageView = _rightImageView;
@synthesize beautifulIdLabel = _beautifulIdLabel;
@synthesize cityLabel = _cityLabel;
@synthesize levelLabelTitle = _levelLabelTitle;
@synthesize editButton = _editButton;
@synthesize updateAvatarButton = _updateAvatarButton;
@synthesize editImageView = _editImageView;
@synthesize vMarkImageView = _vMarkImageView;

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
