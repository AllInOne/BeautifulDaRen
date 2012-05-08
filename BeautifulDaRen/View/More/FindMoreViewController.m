//
//  FindMoreViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/8/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindMoreViewController.h"
#import "ContactItemCell.h"

#define X_OFFSET 5
#define X_DELTA 60
@interface FindMoreViewController()

@property (retain, nonatomic) IBOutlet UIButton * followOrInviteSinaWeiboFriendButton;
@property (retain, nonatomic) IBOutlet UIScrollView * sameCityDaRenView;
@property (retain, nonatomic) IBOutlet UIScrollView * youMayInterestinView;
@property (retain, nonatomic) IBOutlet UIScrollView * hotDaRenView;

- (void) refreshSameCityDaRenView;
- (void) refreshYouMayInterestinView;
- (void) refreshHotDaRenView;

@end

@implementation FindMoreViewController
@synthesize sameCityDaRenView = _sameCityDaRenView;
@synthesize youMayInterestinView = _youMayInterestinView;
@synthesize hotDaRenView = _hotDaRenView;

@synthesize followOrInviteSinaWeiboFriendButton = _followOrInviteSinaWeiboFriendButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)refreshSameCityDaRenView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    for (int i = 0; i < 10; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * X_DELTA, 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += X_DELTA;
        
        [_sameCityDaRenView addSubview:cell];
        
        cell.contactImageView.image = [UIImage imageNamed:@"item_fake"];
        
    }
    [_sameCityDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}

-(void) refreshYouMayInterestinView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    for (int i = 0; i < 10; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * X_DELTA, 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += X_DELTA;
        
        [_youMayInterestinView addSubview:cell];
        
        cell.contactImageView.image = [UIImage imageNamed:@"item_fake"];
        
    }
    [_youMayInterestinView setContentSize:CGSizeMake(scrollWidth, 0)];
}

- (void) refreshHotDaRenView
{
    static NSString * cellViewIdentifier = @"ContactItemCell";
    NSInteger scrollWidth = 0;
    for (int i = 0; i < 10; i++) {
        ContactItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellViewIdentifier owner:self options:nil] objectAtIndex:0];
        cell.frame = CGRectMake(i * X_DELTA, 0,
                                cell.frame.size.width,
                                cell.frame.size.height);
        scrollWidth += X_DELTA;
        
        [_hotDaRenView addSubview:cell];
        
        cell.contactImageView.image = [UIImage imageNamed:@"item_fake"];
        
    }
    [_hotDaRenView setContentSize:CGSizeMake(scrollWidth, 0)];
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [_sameCityDaRenView release];
    [_hotDaRenView release];
    [_youMayInterestinView release];
}

-(void)refreshView
{
    [self refreshSameCityDaRenView];
    [self refreshHotDaRenView];
    [self refreshYouMayInterestinView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
