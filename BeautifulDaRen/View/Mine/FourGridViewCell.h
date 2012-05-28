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

@interface FourGridViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet OHAttributedLabel * firstLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * secondLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * thirdLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * fourthLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * fifthLabel;
@property (retain, nonatomic) IBOutlet OHAttributedLabel * sixthLabel;

@property (retain, nonatomic) IBOutlet UIButton * leftTopButton;
@property (retain, nonatomic) IBOutlet UIButton * leftButtomButton;
@property (retain, nonatomic) IBOutlet UIButton * rightTopButton;
@property (retain, nonatomic) IBOutlet UIButton * rightButtomButton;
@property (retain, nonatomic) IBOutlet UIButton * thirdLeftButton;
@property (retain, nonatomic) IBOutlet UIButton * thirdRightButton;

@property (retain, nonatomic) id<ButtonPressDelegate> delegate;

@end
