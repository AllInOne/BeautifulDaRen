//
//  ContactItemCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderImageView.h"

@interface FriendItemCell : UIView

@property (retain, nonatomic) IBOutlet BorderImageView * friendImageView;
@property (retain, nonatomic) IBOutlet UILabel * friendNameLabel;
@property (retain, nonatomic) IBOutlet UIButton * actionButton;

@end
