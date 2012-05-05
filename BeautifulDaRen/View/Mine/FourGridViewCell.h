//
//  FourGridViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonPressDelegate.h"

@interface FourGridViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel * leftTopLabelName;
@property (retain, nonatomic) IBOutlet UILabel * leftTopLabelNumber;
@property (retain, nonatomic) IBOutlet UILabel * rightTopLabelName;
@property (retain, nonatomic) IBOutlet UILabel * rightTopLabelNumber;
@property (retain, nonatomic) IBOutlet UILabel * leftBottomLabelName;
@property (retain, nonatomic) IBOutlet UILabel * leftBottomLabelNumber;
@property (retain, nonatomic) IBOutlet UILabel * rightBottomLabelName;
@property (retain, nonatomic) IBOutlet UILabel * rightBottomLabelNumber;

@property (retain, nonatomic) IBOutlet UIButton * leftTopButton;
@property (retain, nonatomic) IBOutlet UIButton * leftButtomButton;
@property (retain, nonatomic) IBOutlet UIButton * rightTopButton;
@property (retain, nonatomic) IBOutlet UIButton * rightButtomButton;

@property (retain, nonatomic) id<ButtonPressDelegate> delegate;

@end
