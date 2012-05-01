//
//  GridCellView.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/1/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCellViewDelegate.h"

@interface GridCellView : UIView

@property (retain, nonatomic) IBOutlet UIImageView * cellImageView;
@property (retain, nonatomic) IBOutlet UILabel * cellTitle;

@property (retain, nonatomic) id<GridCellViewDelegate> delegate; 

@end
