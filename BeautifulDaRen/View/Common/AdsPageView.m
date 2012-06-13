//
//  AdsPageView.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsPageView.h"
#import "ViewConstants.h"

#import "iToast.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"

#define ADS_EXCHANGE_TIME_OUT_SECONDS   (5.0)
#define ADS_ANIMATION_DURATION          (0.5)
#define MAX_ADS_PAGES                   (4)

@interface AdsPageView ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) NSArray * adsImageNames;
@property (nonatomic, retain) UIImageView * firstImageView;
@property (nonatomic, retain) UIImageView * secondImageView;

@property (nonatomic, retain) NSTimer * adsExchangeTimer;

@property (nonatomic, assign) bool isNextImageFromLeft;
@property (nonatomic, assign) bool isNextImageInitialized;
@property (nonatomic, assign) bool isAdsAutoChangeDisabled;

-(void)transitionPage:(int)from toPage:(int)to;
-(CATransition *) getAnimation:(NSString *) direction;
- (void)handleTimeOut:(NSTimer*)theTimer;
-(void)setCurrentPageIndex:(int)currentPage;
-(CABasicAnimation*)getAnimation;
@end

@implementation AdsPageView

@synthesize adsPageController = _adsPageController;
@synthesize adsImageNames = _adsImageNames;
@synthesize currentPage;
@synthesize adsExchangeTimer = _adsExchangeTimer;
@synthesize firstImageView = _firstImageView;
@synthesize secondImageView = _secondImageView;
@synthesize delegate = _delegate;

@synthesize adsButton = _adsButton;
@synthesize isNextImageFromLeft = _isNextImageFromLeft;
@synthesize isNextImageInitialized = _isNextImageInitialized;
@synthesize isAdsAutoChangeDisabled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
        self.adsPageController.frame = CGRectMake(self.adsPageController.frame.origin.x, ADS_CELL_HEIGHT - 30, self.adsPageController.frame.size.width, self.adsPageController.frame.size.height);
    }
    return self;  
}

- (void)dealloc {
    [super dealloc];
    
    [_adsImageNames release];
    [_adsPageController release];
    if ([_adsExchangeTimer isValid]) {
        [_adsExchangeTimer invalidate];
    }
    _adsExchangeTimer = nil;
    [_firstImageView release];
    [_secondImageView release];
    [_adsButton release];
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setAdsImageNames:nil];
    self.adsPageController = nil;
    self.firstImageView  = nil;
    self.secondImageView = nil;
    self.adsPageController = nil;
    self.adsButton = nil;
    
    [_adsExchangeTimer invalidate];
    _adsExchangeTimer = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.adsExchangeTimer = [NSTimer timerWithTimeInterval:ADS_EXCHANGE_TIME_OUT_SECONDS
                                                       target:self
                                                     selector:@selector(handleTimeOut:)
                                                     userInfo:nil
                                                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.adsExchangeTimer forMode:NSDefaultRunLoopMode];
    
    UIPanGestureRecognizer * adsDragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onAdsDragged:)];
    [self.view addGestureRecognizer:adsDragGesture];
    [adsDragGesture release];
    
    // TODO: get it from server
    _adsImageNames = [[NSMutableArray alloc] initWithObjects:@"home_banner3",
                      @"home_banner4",
                      @"banner",
                      @"home_banner2",
                      nil];
    _firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_banner3"]];
    _firstImageView.frame = CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT);
    [self.view insertSubview:_firstImageView belowSubview:self.adsPageController];
    
    _secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_banner4"]];
    _secondImageView.frame = CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT);
    [self.view insertSubview:_secondImageView belowSubview:self.adsPageController];
    [_secondImageView setHidden:YES];
    
    self.adsPageController.frame = CGRectMake(self.adsPageController.frame.origin.x, ADS_CELL_HEIGHT - 30, ADS_CELL_WIDTH, ADS_CELL_HEIGHT);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loadView{
    [super loadView];
    //控件区域
    self.adsPageController.numberOfPages = MAX_ADS_PAGES;
    self.adsPageController.currentPage = 0;
    // 设定翻页事件的处理方法
    [self.adsPageController addTarget:self action:@selector(pageTurn:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)handleTimeOut:(NSTimer*)theTimer
{
    if (!self.isAdsAutoChangeDisabled)
    {
        int destPage = 0;
        if (currentPage != (MAX_ADS_PAGES - 1)) {
            destPage = currentPage + 1;
        }
        
        [self transitionPage:currentPage toPage: destPage];
        
        [self setCurrentPageIndex:destPage];
    }
}

-(void)setCurrentPageIndex:(int)pageIndex
{
    [self.adsPageController setCurrentPage:pageIndex];
    self.currentPage = pageIndex;
}

-(void)pageTurn:(UIPageControl*)pageControl{
    [self transitionPage:currentPage toPage: pageControl.currentPage];
}

-(void)transitionPage:(int)from toPage:(int)to{
    if (from!=to) {
        self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
        self.firstImageView.center = CGPointMake(160, self.firstImageView.center.y);
        
        [self.firstImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex:from]]];
        
        CABasicAnimation * firstAnimation = [self getAnimation];
        [firstAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
        [firstAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(-160, self.firstImageView.center.y)]];
        
        [[self.firstImageView layer] addAnimation:firstAnimation forKey:@"firstImageGoBackAutoAnimation"];
        
        [self.secondImageView setHidden:NO];
        [self.secondImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex:to]]];        
        
        CABasicAnimation * secondAnimation = [self getAnimation];
        [secondAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(480, self.secondImageView.center.y)]];
        [secondAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
        
        [[self.secondImageView layer] addAnimation:secondAnimation forKey:@"secondImageGoBackAutoAnimation"];   
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

-(IBAction)onAdsPressed:(id)sender
{
    NSLog(@"Ads Pressed, current ads index = %d", currentPage);
    
//    [[BSDKManager sharedManager] signUpWithUsername:K_BSDK_TEST_USERNAME password:@"1212121212" email:@"sdfsdf@121.com" city:@"成都" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//         NSLog(@"operation done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//    }];
    
    if (![[BSDKManager sharedManager] isLogin])
    {
        [[BSDKManager sharedManager] loginWithUsername:K_BSDK_TEST_USERNAME password:@"1212121212" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            NSLog(@"sign in done = %d", status);
            [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
        }];
    }
    else
    {
//        [[BSDKManager sharedManager] logoutWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//        }];
//        [[BSDKManager sharedManager] searchWeiboByKeyword:@"k" pageSize:20 pageIndex:0 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//        }];
//        [[BSDKManager sharedManager] followUser:@"tankLiu001" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//        }];
    [[BSDKManager sharedManager] getWeiboListByUsername:nil pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        NSLog(@"sign in done = %d", status);
        [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
    }];
//        [[BSDKManager sharedManager] getWeiboClassesWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//        }];
    }

//    [[BSDKManager sharedManager] getUserInforByUsername:K_BSDK_TEST_USERNAME andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//         NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//    }];
    
//    [[BSDKManager sharedManager] searchUsersByUsername:@"121asdfasdf" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//         NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//    }];
//    [[BSDKManager sharedManager] getWeiboListByUsername:K_BSDK_TEST_USERNAME pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSArray *data) {
//        NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//    }];
}

-(IBAction)onAdsPageClosedPressed:(id)sender
{
    NSLog(@"Ads page view close buttion Pressed!");
    if ([self.delegate respondsToSelector:@selector(onAdsPageViewClosed)]) {
        [self.delegate onAdsPageViewClosed];
    }
}

- (void)onAdsDragged:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
            self.firstImageView.center = CGPointMake(160, self.firstImageView.center.y);
            [self.firstImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex:self.currentPage]]];
            self.isNextImageInitialized = NO;
            self.isAdsAutoChangeDisabled = YES;
            [self.firstImageView setHidden:NO];
            [self.secondImageView setHidden:NO];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint delta = [sender translationInView:self.firstImageView];
            if (delta.x != 0) {
                int nextAdsPage = 0;
                if ((self.firstImageView.center.x + delta.x) > 160)
                {
                    _isNextImageFromLeft = YES;
                }
                else
                {
                    _isNextImageFromLeft = NO;
                }
                
                if (!self.isNextImageInitialized)
                {
                    if (_isNextImageFromLeft) {
                        nextAdsPage = (self.currentPage > 0 ? (self.currentPage - 1) : (MAX_ADS_PAGES - 1));
                    }
                    else
                    {
                        nextAdsPage = (self.currentPage < (MAX_ADS_PAGES - 1) ? (self.currentPage + 1) : 0);                    
                    }
                    [self.secondImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex: nextAdsPage]]];
                self.secondImageView.center = CGPointMake(self.firstImageView.center.x + ( _isNextImageFromLeft ? (-320) : 320 ), self.firstImageView.center.y);
                    self.isNextImageInitialized = YES;
                }
                                                
                self.firstImageView.center = CGPointMake(self.firstImageView.center.x + delta.x, self.firstImageView.center.y);
                self.secondImageView.center = CGPointMake(self.secondImageView.center.x + delta.x, self.secondImageView.center.y);
                [sender setTranslation:CGPointZero inView:self.secondImageView];
                [sender setTranslation:CGPointZero inView:self.firstImageView];
            }

            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: 
        {
            CABasicAnimation *firstImageGoBackAnimation = [self getAnimation];
            [firstImageGoBackAnimation setFromValue:[NSValue valueWithCGPoint:self.firstImageView.center]];

            CABasicAnimation *secondImageGoBackAnimation = [self getAnimation];
            [secondImageGoBackAnimation setFromValue:[NSValue valueWithCGPoint:self.secondImageView.center]];

            if (self.firstImageView.center.x <= 90)
            {
                [firstImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(-160, self.firstImageView.center.y)]];
                self.firstImageView.center = CGPointMake(-160, self.firstImageView.center.y);
                
                
                [secondImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
                self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
                
                [self setCurrentPageIndex:(self.currentPage < (MAX_ADS_PAGES - 1) ? (self.currentPage + 1) : 0)];
            }
            else if (self.firstImageView.center.x >= 270)
            {
                [firstImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(480, self.firstImageView.center.y)]];
                self.firstImageView.center = CGPointMake(480, self.firstImageView.center.y);
                
                
                [secondImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
                self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
                
                [self setCurrentPageIndex:(self.currentPage > 0 ? (self.currentPage - 1) : (MAX_ADS_PAGES - 1))];
            }
            else
            {
                [firstImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.firstImageView.center.y)]];
                self.firstImageView.center = CGPointMake(160, self.firstImageView.center.y);

                if (self.isNextImageFromLeft) {
                    [secondImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(-160, self.secondImageView.center.y)]];
                    self.secondImageView.center = CGPointMake(-160, self.secondImageView.center.y); 
                }
                else
                {
                    [secondImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(480, self.secondImageView.center.y)]];
                    self.secondImageView.center = CGPointMake(480, self.secondImageView.center.y); 
                }
            }
            
            [[self.firstImageView layer] addAnimation:firstImageGoBackAnimation forKey:@"firstImageGoBackAnimation"];
            [[self.secondImageView layer] addAnimation:secondImageGoBackAnimation forKey:@"secondImageGoBackAnimation"];
            self.isAdsAutoChangeDisabled = NO;
            break;
        }
        default:
            break;
    }
}
-(CABasicAnimation*)getAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:ADS_ANIMATION_DURATION];
    [animation setBeginTime:CACurrentMediaTime()];
    [animation setAutoreverses:NO];
    [animation setRepeatCount:0];
    
    return animation;
}
@end
