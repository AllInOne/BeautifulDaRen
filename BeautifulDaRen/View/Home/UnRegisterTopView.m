//
//  UnRegisterTopView.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/19/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "UnRegisterTopView.h"
@interface UnRegisterTopView()

- (IBAction)loginBtnSelected:(UIButton*)sender;
- (IBAction)registerBtnSelected:(UIButton*)sender;

@end

@implementation UnRegisterTopView

@synthesize loginBtn;
@synthesize registerBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark Action
- (IBAction)loginBtnSelected:(UIButton*)sender
{
    NSLog(@"loginBtnSelected");
}
- (IBAction)registerBtnSelected:(UIButton*)sender
{
    NSLog(@"registerBtnSelected");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
