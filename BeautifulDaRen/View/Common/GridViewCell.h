//
//  FourGridViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"
#import "OHAttributedLabel.h"

@interface GridViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet OHAttributedLabel * firstLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * secondLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * thirdLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * fourthLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * fifthLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * sixthLabel;

@property (retain, nonatomic) IBOutlet UIButton * firstButton;
@property (retain, nonatomic) IBOutlet UIButton * secondButton;
@property (retain, nonatomic) IBOutlet UIButton * thirdButton;
@property (retain, nonatomic) IBOutlet UIButton * fourthButton;
@property (retain, nonatomic) IBOutlet UIButton * fifthButton;
@property (retain, nonatomic) IBOutlet UIButton * sixthButton;
@property (retain, nonatomic) IBOutlet UIImageView *secondBadgeView;

@property (retain, nonatomic) id<ButtonPressDelegate> delegate;

@end
