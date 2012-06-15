//
//  ButtonWithIconViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"

@interface ButtonViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * buttonLeftIcon;
@property (retain, nonatomic) UIImage * buttonLeftIconPressed;
@property (retain, nonatomic) IBOutlet UILabel * buttonText;
@property (retain, nonatomic) IBOutlet UIImageView * buttonRightIcon;
@property (retain, nonatomic) IBOutlet UILabel * buttonRightText;
@property (retain, nonatomic) IBOutlet UILabel * leftLabel;
@property (retain, nonatomic) IBOutlet UIButton * leftButton;
@property (retain, nonatomic) IBOutlet UIButton * rightButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl * segmentedControl;

@property (assign, nonatomic) id<ButtonPressDelegate> delegate;

@end
