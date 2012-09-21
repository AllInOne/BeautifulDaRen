//
//  SegmentControl.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/30/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "SegmentControl.h"

@implementation SegmentControl
@synthesize firstButton = _firstButton;
@synthesize secondButton = _secondButton;

-(void) dealloc
{
    [super dealloc];
    [_firstButton release];
    [_secondButton release];
}

-(void)onButtonClicked:(UIButton*)button{
    if(button == _firstButton)
    {
        [_firstButton setSelected:YES];
        [_secondButton setSelected:NO];
    }
    else if (button == _secondButton)
    {
        [_firstButton setSelected:NO];
        [_secondButton setSelected:YES];
    }
}

- (id) initWithFrame:(CGRect)frame leftText:(NSString *)leftText rightText:(NSString*)rightText selectedIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 29)];
        _secondButton = [[UIButton alloc] initWithFrame:CGRectMake(56, 0, 56, 29)];
        [_firstButton setTitle:leftText forState:UIControlStateNormal];
        [_firstButton setTitle:leftText forState:UIControlStateSelected];
        [_firstButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_firstButton setTitleColor:[UIColor colorWithRed:(128.0f/255.0f) green:(39.0f/255.0f) blue:(73.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        [_firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_firstButton setBackgroundImage:[UIImage imageNamed:@"segement_btn_left_unselected"] forState:UIControlStateNormal];
        [_firstButton setBackgroundImage:[UIImage imageNamed:@"segement_btn_left_selected"] forState:UIControlStateSelected];

        [_firstButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [_secondButton setTitle:rightText forState:UIControlStateNormal];
        [_secondButton setTitle:rightText forState:UIControlStateSelected];
        [_secondButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_secondButton setTitleColor:[UIColor colorWithRed:(128.0f/255.0f) green:(39.0f/255.0f) blue:(73.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        [_secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [_secondButton setBackgroundImage:[UIImage imageNamed:@"segement_btn_right_unselected"] forState:UIControlStateNormal];
        [_secondButton setBackgroundImage:[UIImage imageNamed:@"segement_btn_right_selected"] forState:UIControlStateSelected];
        [_secondButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        if (index == 0) {
            [_firstButton setSelected:YES];
        }
        else {
            [_secondButton setSelected:YES];
        }
        [self addSubview:_firstButton];
        [self addSubview:_secondButton];
    }
    return self;
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
