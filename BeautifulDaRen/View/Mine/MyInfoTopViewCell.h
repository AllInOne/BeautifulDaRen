//
//  MyInfoTopViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/2/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoTopViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * avatarImageView;
@property (retain, nonatomic) IBOutlet UIImageView * levelImageView;
@property (retain, nonatomic) IBOutlet UIImageView * leftImageView;
@property (retain, nonatomic) IBOutlet UILabel * beautifulIdLabel;
@property (retain, nonatomic) IBOutlet UILabel * levelLabel;
@property (retain, nonatomic) IBOutlet UILabel * cityLabel;

@end
