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

@implementation CategoryItemCell

@synthesize categoryScrollItem = _categoryScrollItem;
@synthesize categoryTitle = _categoryTitle;

- (void)dealloc {
    [_categoryScrollItem release];
    [_categoryTitle release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title: (NSString*)title andData: (NSArray *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        // TODO: test code

        _categoryScrollItem = [[CommonScrollView alloc] initWithNibName:nil bundle:nil data:data andDelegate:self];

        [self.view addSubview:_categoryScrollItem.view];
        
        _categoryScrollItem.view.frame = CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, CATEGORY_ITEM_HEIGHT);
        
        self.categoryTitle.text = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _categoryScrollItem = nil;
    _categoryTitle = nil;
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
