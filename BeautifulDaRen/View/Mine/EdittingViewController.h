//
//  EdittingViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 5/22/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

enum
{
    EdittingViewController_type0 = 0,
    EdittingViewController_type1
};

@interface EdittingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView * inputTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type;
@end
