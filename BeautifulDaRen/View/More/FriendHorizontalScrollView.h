//
//  FriendHorizontalScrollView.h
//  BeautifulDaRen
//
//  Created by gang liu on 6/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonScrollView.h"

@interface FriendHorizontalScrollView : UIViewController<CommonScrollViewProtocol>

@property (retain, nonatomic) CommonScrollView * friendScrollView;
@property (retain, nonatomic) IBOutlet UILabel * friendScrollTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title: (NSString*)title andData: (NSArray *)data;

@end
