//
//  MyInfoTopViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorderImageView.h"
@interface MyInfoTopViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet BorderImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UIImageView * vMarkImageView;
@property (retain, nonatomic) IBOutlet UILabel * levelLabel;
@property (retain, nonatomic) IBOutlet UIImageView * rightImageView;
@property (retain, nonatomic) IBOutlet UILabel * beautifulIdLabel;
@property (retain, nonatomic) IBOutlet UILabel * levelLabelTitle;
@property (retain, nonatomic) IBOutlet UILabel * cityLabel;
@property (retain, nonatomic) IBOutlet UIButton * editButton;
@property (retain, nonatomic) IBOutlet UIButton * updateAvatarButton;
@property (retain, nonatomic) IBOutlet UIImageView * editImageView;

@end
