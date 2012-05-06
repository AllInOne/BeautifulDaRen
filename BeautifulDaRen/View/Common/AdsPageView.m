//
//  AdsPageView.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsPageView.h"
#import "ViewConstants.h"

#define ADS_EXCHANGE_TIME_OUT_SECONDS   (3.0)
#define MAX_ADS_PAGES                   (4)

@interface AdsPageView ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) NSMutableArray * adsImageNames;
@property (nonatomic, assign) UIImageView * firstImageView;
@property (nonatomic, assign) UIImageView * secondImageView;

@property (nonatomic, retain) NSTimer * adsExchangeTimer;
-(void)transitionPage:(int)from toPage:(int)to;
-(CATransition *) getAnimation:(NSString *) direction;
- (void)handleTimeOut:(NSTimer*)theTimer;
@end

@implementation AdsPageView

@synthesize adsPageController = _adsPageController;
@synthesize adsImageNames = _adsImageNames;
@synthesize currentPage;
@synthesize adsExchangeTimer = _adsExchangeTimer;
@synthesize firstImageView = _firstImageView;
@synthesize secondImageView = _secondImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, ADS_CELL_HEIGHT);
        // TODO: get it from server
        _adsImageNames = [[NSMutableArray alloc] initWithObjects:@"banner320x136.png",
                                                                 @"banner320x136.png",
                                                                 @"banner320x136.png",
                                                                 @"banner320x136.png",
                                                                 nil];
        _firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner320x136.png"]];
        _firstImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:_firstImageView belowSubview:self.adsPageController];
        
        _secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner320x136.png"]];
        _secondImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view insertSubview:_secondImageView belowSubview:self.adsPageController];
        [_secondImageView setHidden:YES];
        
        self.adsPageController.frame = CGRectMake(self.adsPageController.frame.origin.x, ADS_CELL_HEIGHT - 30, self.adsPageController.frame.size.width, self.adsPageController.frame.size.height);
    }
    return self;  
}

- (void)dealloc {
    [_adsPageController release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    [_adsExchangeTimer invalidate];
    [_adsExchangeTimer release];
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
    int destPage = 0;
    if (currentPage != (MAX_ADS_PAGES - 1)) {
        destPage = currentPage + 1;
    }
    
    [self transitionPage:currentPage toPage: destPage];
    
    [self.adsPageController setCurrentPage:destPage];
    currentPage = destPage;
}

-(void)pageTurn:(UIPageControl*)pageControl{
    [self transitionPage:currentPage toPage: pageControl.currentPage];
}

-(void)transitionPage:(int)from toPage:(int)to{
    if (from!=to) {

            [self.firstImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex:from]]];
            [self.secondImageView setImage:[UIImage imageNamed:[self.adsImageNames objectAtIndex:to]]];
        
            [self.firstImageView setHidden:NO];
            [self.secondImageView setHidden:YES];

        [[self.firstImageView layer] addAnimation:[self getAnimation:kCATransitionFromRight] forKey:@"pageTurnAnimation"];
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
}

@end
