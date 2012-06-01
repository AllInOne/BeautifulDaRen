//
//  FriendListViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 6/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderImageView.h"

@interface FriendListViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet BorderImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UILabel * friendNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * friendWeiboLabel;
@property (retain, nonatomic) IBOutlet UIButton * actionButton;

@end
