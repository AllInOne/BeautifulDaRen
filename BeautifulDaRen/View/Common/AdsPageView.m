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

#import "UIImageView+WebCache.h"

#import "WeiboDetailViewController.h"
#import "FriendDetailViewController.h"

#define ADS_EXCHANGE_TIME_OUT_SECONDS   (5.0)
#define ADS_ANIMATION_DURATION          (0.5)
//#define MAX_ADS_PAGES                   (4)

@interface AdsPageView ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int totalPageSize;
@property (nonatomic, retain) NSMutableArray * adsImageNames;
@property (nonatomic, retain) NSArray * adsImageData;
@property (nonatomic, retain) UIImageView * firstImageView;
@property (nonatomic, retain) UIImageView * secondImageView;

@property (nonatomic, retain) NSTimer * adsExchangeTimer;

@property (nonatomic, retain) UIPanGestureRecognizer * adsDragGesture;

@property (nonatomic, assign) bool isNextImageFromLeft;
@property (nonatomic, assign) bool isNextImageInitialized;
@property (nonatomic, assign) bool isAdsAutoChangeDisabled;

- (void)initControls;

- (void)downloadAllImagesWithCallback:(processDoneBlock)callback;

-(void)transitionPage:(int)from toPage:(int)to;
-(CATransition *) getAnimation:(NSString *) direction;
- (void)handleTimeOut:(NSTimer*)theTimer;
-(void)setCurrentPageIndex:(int)currentPage;
-(CABasicAnimation*)getAnimation;
@end

@implementation AdsPageView

@synthesize adsPageController = _adsPageController;
@synthesize adsImageNames = _adsImageNames;
@synthesize adsImageData = _adsImageData;
@synthesize currentPage;
@synthesize adsExchangeTimer = _adsExchangeTimer;
@synthesize firstImageView = _firstImageView;
@synthesize secondImageView = _secondImageView;
@synthesize delegate = _delegate;

@synthesize adsButton = _adsButton;
@synthesize closeButton = _closeButton;
@synthesize isNextImageFromLeft = _isNextImageFromLeft;
@synthesize isNextImageInitialized = _isNextImageInitialized;
@synthesize isAdsAutoChangeDisabled;
@synthesize totalPageSize = _totalPageSize;
@synthesize adsDragGesture = _adsDragGesture;

@synthesize city = _city;
@synthesize type = _type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[BSDKManager sharedManager] isLogin]) {
            self.type = K_BSDK_ADSTYPE_LOGIN;
        }
        else
        {
            self.type = K_BSDK_ADSTYPE_LOGOUT;
        }
        
        self.city = K_BSDK_DEFAULT_CITY;
        
////        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
//        self.adsPageController.frame = CGRectMake(self.adsPageController.frame.origin.x, ADS_CELL_HEIGHT - 30, self.adsPageController.frame.size.width, self.adsPageController.frame.size.height);
    }
    return self;  
}

- (void)dealloc {
    [_adsImageNames release];
    [_adsPageController release];
    if ([_adsExchangeTimer isValid]) {
        [_adsExchangeTimer invalidate];
    }
    _adsExchangeTimer = nil;
    [_firstImageView release];
    [_secondImageView release];
    [_adsButton release];
    [_city release];
    [_adsImageData release];
    [_adsDragGesture release];
    [_closeButton release];
    
    [super dealloc];
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
    self.adsImageData = nil;
    self.closeButton = nil;
}

-(void)stop
{
    if ([_adsExchangeTimer isValid]) {
        [_adsExchangeTimer invalidate];
        _adsExchangeTimer = nil;
    }
}

- (void)refreshView
{
    [self stop];
    [_firstImageView setHidden:YES];
    [_secondImageView setHidden:YES];
    [_closeButton setHidden:YES];
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, ADS_CELL_HEIGHT/2);
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
    
    [[BSDKManager sharedManager] getAdsByCity:_city
                                         type:_type
                              andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                  
                                  if (K_BSDK_IS_RESPONSE_OK(data)) {
                                      self.adsImageData = nil;
                                      self.adsImageData = [data objectForKey:K_BSDK_ADSLIST];
                                      self.totalPageSize = [self.adsImageData count];
                                      if (_adsImageNames)
                                      {
                                          [_adsImageNames removeAllObjects];
                                      }
                                      else
                                      {
                                          _adsImageNames = [[NSMutableArray alloc] initWithCapacity: self.totalPageSize];
                                      }
                                      
                                      for (NSDictionary * ad in self.adsImageData) {
                                          if (IS_RETINA)
                                          {
                                              [_adsImageNames addObject:[ad objectForKey:K_BSDK_IMAGEURL_RETINA]];
                                          }
                                          else
                                          {
                                              [_adsImageNames addObject:[ad objectForKey:K_BSDK_IMAGEURL]];
                                          }
                                      }
                                      
                                      [self downloadAllImagesWithCallback:^(AIO_STATUS status) {
                                          [_closeButton setHidden:NO];
                                          [self initControls];
                                          

                                          [activityIndicator stopAnimating];
                                          [activityIndicator removeFromSuperview];
                                          [activityIndicator release];
                                      }];
                                  }
                                  else
                                  {
                                      [activityIndicator stopAnimating];
                                      [activityIndicator removeFromSuperview];
                                      [activityIndicator release];
                                      [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                                  }
                              }];
}

- (void)downloadAllImagesWithCallback:(processDoneBlock)callback
{
    __block NSInteger imageCount = [self.adsImageNames count];
    if (imageCount) {
        __block NSInteger downloadedImageCount = 0;
        imageDownloadFailureBlock failureBlock = ^(NSError *error){
            downloadedImageCount++;
            if (downloadedImageCount >= imageCount) {
                callback(AIO_STATUS_SUCCESS);
            }
        };
        
        imageDownloadSuccessBlock successBlock = ^(UIImage *image){
            downloadedImageCount++;
            if (downloadedImageCount >= imageCount) {
                callback(AIO_STATUS_SUCCESS);
            }
        };
        
        NSLog(@"%@", self.adsImageNames);
        for (NSString * imageUrl in self.adsImageNames) {
            UIImageView * falkImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT)] autorelease];
            [falkImageView setImageWithURL:[NSURL URLWithString:imageUrl] success:successBlock failure:failureBlock];
        }
    }
    else
    {
        callback(AIO_STATUS_NOT_FOUND);
    }
}

- (void)initControls
{
    if (self.adsExchangeTimer == nil && ([self.adsImageNames count] > 1)) {
        self.adsExchangeTimer = [NSTimer timerWithTimeInterval:ADS_EXCHANGE_TIME_OUT_SECONDS
                                                        target:self
                                                      selector:@selector(handleTimeOut:)
                                                      userInfo:nil
                                                       repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.adsExchangeTimer forMode:NSDefaultRunLoopMode];
    }

    if (self.firstImageView == nil)
    {
        _firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT)];
        [self.view insertSubview:_firstImageView belowSubview:self.adsPageController];
    }
    [_firstImageView setImageWithURL:[NSURL URLWithString:[_adsImageNames objectAtIndex:0]]];
    [_firstImageView setHidden:NO];
    [_firstImageView setBackgroundColor:[UIColor whiteColor]];
    
    if ([self.adsImageNames count] > 1) {
        if (self.secondImageView == nil) {
            _secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ADS_CELL_WIDTH, ADS_CELL_HEIGHT)];
            [self.view insertSubview:_secondImageView belowSubview:self.adsPageController];
            [_secondImageView setHidden:YES];
        }
        
        [_secondImageView setImageWithURL:[NSURL URLWithString:[_adsImageNames objectAtIndex:1]]];
        [_secondImageView setHidden:NO];
        [_secondImageView setBackgroundColor:[UIColor whiteColor]];
        
        if (_adsDragGesture == nil) {
            _adsDragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onAdsDragged:)];
            [self.view addGestureRecognizer:_adsDragGesture];
        }
    }

    //set all the images to download them all at the beginning
    self.adsPageController.numberOfPages =  self.totalPageSize;
    self.adsPageController.frame = CGRectMake(SCREEN_WIDTH - 10 * (self.totalPageSize + 1), ADS_CELL_HEIGHT - 30, ADS_PAGE_CONTROLLER_DOT_WIDTH * self.totalPageSize, CGRectGetHeight(self.adsPageController.frame));
    
    [self setCurrentPageIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//-(void)loadView{
//    [super loadView];
//    //控件区域
//    // 设定翻页事件的处理方法
//    [self.adsPageController addTarget:self action:@selector(pageTurn:)
//                  forControlEvents:UIControlEventValueChanged];
//}

- (void)handleTimeOut:(NSTimer*)theTimer
{
    if (!self.isAdsAutoChangeDisabled)
    {
        int destPage = 0;
        if (currentPage != ( self.totalPageSize - 1)) {
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
    NSString* imgActive = [[NSBundle mainBundle] pathForResource:@"banner_switcher_focus" ofType:@"png"]; 
    NSString* imgInactive = [[NSBundle mainBundle] pathForResource:@"banner_switcher_normal" ofType:@"png"]; 
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.adsPageController.subviews count]; subviewIndex++) { 
        UIImageView* subview = [self.adsPageController.subviews objectAtIndex:subviewIndex]; 
        if (subviewIndex == self.currentPage) { 
            [subview setImage:[UIImage imageWithContentsOfFile:imgActive]]; 
        } else { 
            [subview setImage:[UIImage imageWithContentsOfFile:imgInactive]]; 
        } 
        //        subview.frame = CGRectMake(/* position and dimensi***** you need */); 
    }
}

-(void)pageTurn:(UIPageControl*)pageControl{
    [self transitionPage:currentPage toPage: pageControl.currentPage];
}

-(void)transitionPage:(int)from toPage:(int)to{
    if (from!=to) {
        self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
        self.firstImageView.center = CGPointMake(160, self.firstImageView.center.y);
        
        [self.firstImageView setImageWithURL:[NSURL URLWithString:[_adsImageNames objectAtIndex:from]]];
        
        CABasicAnimation * firstAnimation = [self getAnimation];
        [firstAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
        [firstAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(-160, self.firstImageView.center.y)]];
        
        [[self.firstImageView layer] addAnimation:firstAnimation forKey:@"firstImageGoBackAutoAnimation"];
        
        [self.secondImageView setHidden:NO];
        [self.secondImageView setImageWithURL:[NSURL URLWithString:[_adsImageNames objectAtIndex:to]]];        
        
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
    
    NSDictionary * adsDict = [self.adsImageData objectAtIndex:currentPage];
    
    if ([[adsDict objectForKey:K_BSDK_ADS_LINKTYPE] isEqual:K_BSDK_ADS_LINKTYPE_WEIBO]) {
        WeiboDetailViewController *weiboDetailController = 
        [[WeiboDetailViewController alloc] init];
        
        weiboDetailController.weiboId = [adsDict objectForKey:K_BSDK_ADS_LINKID];
        
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        [navController release];
        [weiboDetailController release]; 
    }
    else
    {
        FriendDetailViewController * friendDetailController = 
        [[FriendDetailViewController alloc] initWithFriendId:[adsDict objectForKey:K_BSDK_ADS_LINKID]];

        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendDetailController];
        
        [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
        [navController release];
        [friendDetailController release];
    }
    
    return;
#ifdef DEBUG
//    [[BSDKManager sharedManager] signUpWithUsername:@"jerry2" password:@"123456" email:@"sdfsdf122@121.com" city:@"成都" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//         NSLog(@"operation done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//    }];
    
    if (![[BSDKManager sharedManager] isLogin])
    {
        [[BSDKManager sharedManager] loginWithUsername:@"jerry" password:@"123456" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
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
//    [[BSDKManager sharedManager] getWeiboListByUsername:@"32" pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//        NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//    }];
//        [[BSDKManager sharedManager] getHotUsersByCity:@"成都" userType:K_BSDK_USERTYPE_INTERESTED pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//        }];
        

//        [[BSDKManager sharedManager] getWeiboClassesWithDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//        }];

//            [[BSDKManager sharedManager] getUserInforByUserId:@"32" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//                 NSLog(@"sign in done = %d", status);
//                [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//                }];
//    [[BSDKManager sharedManager] getAtWeiboListByUserId:@"32" pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//        NSLog(@"sign in done = %d", status);
//        //[[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//    }];
//        
//    [[BSDKManager sharedManager] getCommentListOfUser:@"32" pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            //[[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//        }];
//        [[BSDKManager sharedManager] getFollowList:@"32" pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//            NSLog(@"sign in done = %d", status);
//            [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//        }];
        
    }
    
//    [[BSDKManager sharedManager] searchUsersByUsername:@"121asdfasdf" andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
//         NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
//    }];
//    [[BSDKManager sharedManager] getWeiboListByUsername:K_BSDK_TEST_USERNAME pageSize:20 pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSArray *data) {
//        NSLog(@"sign in done = %d", status);
//        [[iToast makeText:[NSString stringWithFormat:@"%@", [data description]]] show];
//    }];
    
#endif
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
            [self.firstImageView setImageWithURL:[NSURL URLWithString:[self.adsImageNames objectAtIndex:self.currentPage]]];
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
                        nextAdsPage = (self.currentPage > 0 ? (self.currentPage - 1) : ( self.totalPageSize - 1));
                    }
                    else
                    {
                        nextAdsPage = (self.currentPage < ( self.totalPageSize - 1) ? (self.currentPage + 1) : 0);                    
                    }
                    [self.secondImageView setImageWithURL:[NSURL URLWithString:[self.adsImageNames objectAtIndex: nextAdsPage]]];
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
                
                [self setCurrentPageIndex:(self.currentPage < ( self.totalPageSize - 1) ? (self.currentPage + 1) : 0)];
            }
            else if (self.firstImageView.center.x >= 270)
            {
                [firstImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(480, self.firstImageView.center.y)]];
                self.firstImageView.center = CGPointMake(480, self.firstImageView.center.y);
                
                
                [secondImageGoBackAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(160, self.secondImageView.center.y)]];
                self.secondImageView.center = CGPointMake(160, self.secondImageView.center.y);
                
                [self setCurrentPageIndex:(self.currentPage > 0 ? (self.currentPage - 1) : ( self.totalPageSize - 1))];
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
