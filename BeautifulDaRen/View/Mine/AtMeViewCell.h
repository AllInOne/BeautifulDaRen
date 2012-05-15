//
//  AtMeViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/14/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtMeViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * friendImageView;
@property (retain, nonatomic) IBOutlet UIImageView * itemImageView;
@property (retain, nonatomic) IBOutlet UILabel * friendNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * timeLabel;
@property (retain, nonatomic) IBOutlet UILabel * shopNameLabel;
@property (retain, nonatomic) IBOutlet UILabel * brandLabel;
@property (retain, nonatomic) IBOutlet UILabel * costLabel;
@property (retain, nonatomic) IBOutlet UITextView * descriptionView;

@end
