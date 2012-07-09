//
//  CategoryItemCell.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryItemCell.h"
#import "ViewConstants.h"
#import "WeiboDetailViewController.h"
#import "WeiboComposerViewController.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "WeiboListViewController.h"

#define CLASS_WEIBO_PAGE_SIZE   (20.0)

@interface CategoryItemCell ()
@property (nonatomic, retain) NSDictionary * itemData;
@property (nonatomic, retain) NSMutableArray * weiboList;

-(NSArray*)getPicturesFromWeiboList;
@end

@implementation CategoryItemCell

@synthesize categoryScrollItem = _categoryScrollItem;
@synthesize categoryTitle = _categoryTitle;
@synthesize itemData = _itemData;
@synthesize weiboList = _weiboList;

- (void)dealloc {
    [_categoryScrollItem release];
    [_categoryTitle release];
    [_itemData release];
    [_weiboList release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSDictionary*)category
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        // TODO: test code
        self.itemData = category;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoryTitle.text = [self.itemData objectForKey:K_BSDK_CLASSNAME];
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.frame = CGRectMake(SCREEN_WIDTH/2, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
    
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: TRUE];
    
    [[BSDKManager sharedManager] getWeiboListByClassId:[self.itemData objectForKey:K_BSDK_UID] pageSize:CLASS_WEIBO_PAGE_SIZE pageIndex:1 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: FALSE];
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        
        self.weiboList = [NSMutableArray arrayWithCapacity:CLASS_WEIBO_PAGE_SIZE];
        
        NSArray * classWeiboList = [data objectForKey:K_BSDK_BLOGLIST];
        for (NSDictionary * weibo in classWeiboList) {
            if ([weibo objectForKey:K_BSDK_PICTURE_102]) {
                [self.weiboList addObject:weibo];
            }
        }
        
        _categoryScrollItem = [[CommonScrollView alloc] initWithNibName:nil bundle:nil data:[self getPicturesFromWeiboList] andDelegate:self];
        
        [self.view addSubview:_categoryScrollItem.view];
        
        _categoryScrollItem.view.frame = CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, CATEGORY_ITEM_HEIGHT);
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCategoryTitle:nil];
    [self setCategoryScrollItem:nil];
    [self setWeiboList:nil];
}

- (void)onItemSelected:(int)index
{
    NSLog(@"Category %d selected", index);
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] initWithDictionary:[self.weiboList objectAtIndex:index]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (IBAction)onMoreButtonPressed:(id)sender
{
    WeiboListViewController * categoryViewController = [[WeiboListViewController alloc]
                                                        initWithNibName:nil
                                                        bundle:nil
                                                        type:WeiboListViewControllerType_CATEGORY
                                                        dictionary:self.itemData];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: categoryViewController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [categoryViewController release];
}

- (CGFloat)getHeight
{
    return CATEGORY_ITEM_HEIGHT;
}

-(NSArray*)getPicturesFromWeiboList
{
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:[self.weiboList count]];
    
    for (NSDictionary * weiboData in self.weiboList) {
        NSString * pictureUrl = [weiboData objectForKey:K_BSDK_PICTURE_102];
        if (pictureUrl) {
            [ret addObject:[weiboData objectForKey:K_BSDK_PICTURE_102]];
        }
    }

    return ret;
}
@end
