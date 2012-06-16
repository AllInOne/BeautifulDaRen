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

@interface CategoryItemCell ()
@property (nonatomic, retain) NSDictionary * itemData;
@end

@implementation CategoryItemCell

@synthesize categoryScrollItem = _categoryScrollItem;
@synthesize categoryTitle = _categoryTitle;
@synthesize itemData = _itemData;

- (void)dealloc {
    [_categoryScrollItem release];
    [_categoryTitle release];
    [_itemData release];
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
    
    [[BSDKManager sharedManager] getWeiboListByClassId:[self.itemData objectForKey:K_BSDK_UID] pageSize:20 pageIndex:0 andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        
        NSArray * samples4 = [NSArray arrayWithObjects:@"http://tp2.sinaimg.cn/2788997993/50/0/0", @""@"http://tp2.sinaimg.cn/2788997993/50/0/0", @"http://tp2.sinaimg.cn/2788997993/50/0/0", @"http://tp2.sinaimg.cn/2788997993/50/0/0", nil];
        
        _categoryScrollItem = [[CommonScrollView alloc] initWithNibName:nil bundle:nil data:samples4 andDelegate:self];
        
        [self.view addSubview:_categoryScrollItem.view];
        
        _categoryScrollItem.view.frame = CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, CATEGORY_ITEM_HEIGHT);
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCategoryTitle:nil];
    [self setCategoryScrollItem:nil];
    [self setItemData:nil];
}

- (void)onItemSelected:(int)index
{
    NSLog(@"Category %d selected", index);
    WeiboDetailViewController *weiboDetailController = 
    [[WeiboDetailViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
    [weiboDetailController release];
}

- (CGFloat)getHeight
{
    return CATEGORY_ITEM_HEIGHT;
}
@end
