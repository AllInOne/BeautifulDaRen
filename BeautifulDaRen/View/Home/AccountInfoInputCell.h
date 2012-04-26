//
//  AcountInfoInputCell.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/22/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoInputCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel * inputLabel;
@property (retain, nonatomic) IBOutlet UITextField * inputTextField;
@property (retain, nonatomic) IBOutlet UISegmentedControl * segementedController;
@property (retain, nonatomic) IBOutlet UIImageView * imageView;
@property (retain, nonatomic) IBOutlet UILabel * secondLabel;

@end
