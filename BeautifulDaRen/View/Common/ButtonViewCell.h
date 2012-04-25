//
//  ButtonWithIconViewCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * buttonLeftIcon;
@property (retain, nonatomic) IBOutlet UILabel * buttonText;
@property (retain, nonatomic) IBOutlet UIImageView * buttonRightIcon;

@end
