//
//  AdsPageView.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsPageView.h"

@implementation AdsPageView

@synthesize firstAdsImageView = _firstAdsImageView;
@synthesize secondsAdsImageView = _secondsAdsImageView;
@synthesize adsPageController = _adsPageController;

@synthesize pageView = _pageView;
@synthesize pages = _pages;
@synthesize previousPage;

-(id)init {
    if (self = [super init]) {
        _pages=[[NSMutableArray alloc ]initWithObjects:@"logo.png",
                @"logo@2x.png",
                @"bg_land.png",
                nil];
    }
    return self;
}

- (void)dealloc {
    [_firstAdsImageView release];
    [_secondsAdsImageView release];
    [_adsPageController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadView{
    [super loadView];
    
    CGRect viewBounds = self.view.frame;
    viewBounds.origin.y = 0.0;
    viewBounds.size.height = 460.0;
    //控件区域
    //    self.adsPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(viewBounds.origin.x,
    //                                                           viewBounds.origin.y,
    //                                                           viewBounds.size.width,
    //                                                           60)];
    self.adsPageController.backgroundColor=[UIColor blackColor];
    self.adsPageController.numberOfPages = 3;
    self.adsPageController.currentPage = 0;
    // 设定翻页事件的处理方法
    [self.adsPageController addTarget:self action:@selector(pageTurn:)
                  forControlEvents:UIControlEventValueChanged];
    // 页面区域
    CGRect contentFrame=CGRectMake(viewBounds.origin.x,
                                   viewBounds.origin.y+60,
                                   viewBounds.size.width,
                                   viewBounds.size.height-60);
    self.pageView=[[UIView alloc]initWithFrame:contentFrame];
    [self.pageView setBackgroundColor:[UIColor brownColor]];
    // 添加两个imageview，动画切换时用
    for (int i=0; i<2; i++) {
        [self.pageView addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                contentFrame.size.width,
                                                                                contentFrame.size.height)]];
    }
}

-(void)pageTurn:(UIPageControl*)pageControl{
    [self transitionPage:previousPage toPage:pageControl.currentPage];
    previousPage=pageControl.currentPage;
}

-(void)transitionPage:(int)from toPage:(int)to{
    NSLog(@"previouspage:%d",from);
    NSLog(@"currentpage:%d",to);
    CATransition *transition;
    if (from!=to) {
        if(from<to){
            transition=[self getAnimation:kCATransitionFromLeft];
        }else{
            transition=[self getAnimation:kCATransitionFromRight];
        }
        // 取出pageView的下面的图片作为准备显示的图片
        UIImageView *newImage=(UIImageView *)[[self.pageView subviews] objectAtIndex:0];
        // 将视图修改为要显示的图片
        [newImage setImage:[UIImage imageNamed:[self.pages objectAtIndex:to]]];
        // 将pageView的上下图片交换
        [self.pageView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        // 显示上面的图片，隐藏下面的图片
        [[self.pageView.subviews objectAtIndex:0] setHidden:YES];
        [[self.pageView.subviews objectAtIndex:1] setHidden:NO];
        // 设置转换动画
        [[self.pageView layer] addAnimation:transition forKey:@"pageTurnAnimation"];
    }
}

-(CATransition *) getAnimation:(NSString *) direction
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:direction];
    [animation setDuration:1.0f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}

@end
