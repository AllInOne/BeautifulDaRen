//
//  PrivateLetterViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/17/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateLetterViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * avatarImage;
@property (retain, nonatomic) IBOutlet UILabel * nameLabel;
@property (retain, nonatomic) IBOutlet UILabel * timeLabel;
@property (retain, nonatomic) IBOutlet UITextView * detailView;

@end
