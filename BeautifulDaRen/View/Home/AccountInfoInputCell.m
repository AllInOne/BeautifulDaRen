//
//  AccountInfoInputCell.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/22/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "AccountInfoInputCell.h"

@implementation AccountInfoInputCell

@synthesize inputLabel;
@synthesize inputTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
