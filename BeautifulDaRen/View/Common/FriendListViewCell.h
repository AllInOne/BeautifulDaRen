//
//  FriendListViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderImageView.h"
#import "ButtonPressDelegate.h"

@interface FriendListViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet BorderImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UIImageView * vMarkImageView;
@property (retain, nonatomic) IBOutlet UILabel * friendNameLabel;
@property (retain, nonatomic) IBOutlet UIView * buyStatusView;
@property (retain, nonatomic) IBOutlet UIButton * actionButton;
@property (retain, nonatomic) IBOutlet UILabel * buyStatusLabel;
@property (retain, nonatomic) IBOutlet UIButton * cancelBuyButton;

@property (assign, nonatomic) id<ButtonPressDelegate> delegate;

@end
