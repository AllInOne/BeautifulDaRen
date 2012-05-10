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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title: (NSString*)title andData: (NSDictionary *)dataDict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        // TODO: test code
        NSArray * images = [NSArray arrayWithObjects:
                            @"1",                    
                            @"2",                        
                            @"3",                      
                            @"2",
                            @"3",
                            @"2",
                            @"3",
                            @"2",
                            @"3",
                            nil];
        _categoryScrollItem = [[CommonScrollView alloc] initWithNibName:@"CommonScrollView" bundle:nil data:images andDelegate:self];
        [_categoryScrollItem.view setFrame:CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT *2, self.view.frame.size.width, CATEGORY_ITEM_HEIGHT)];
        [self.view addSubview:_categoryScrollItem.view];
    }
    return self;
}

- (void)onItemSelected:(int)index
{
    NSLog(@"Category %d selected", index);
    WeiboDetailViewController *weiboDetailController = 
    [[[WeiboDetailViewController alloc] init] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
}

- (CGFloat)getHeight
{
    return CATEGORY_ITEM_HEIGHT;
}
@end
