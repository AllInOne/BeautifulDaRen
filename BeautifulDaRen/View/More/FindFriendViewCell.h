//
//  FindFriendViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/23/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderImageView.h"
#import "ButtonPressDelegate.h"

@interface FindFriendViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel * nameLabel;
@property (retain, nonatomic) IBOutlet BorderImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel * levelLabel;
@property (retain, nonatomic) IBOutlet UIButton * followButton;

@property (assign, nonatomic) id<ButtonPressDelegate> delegate;
@end
