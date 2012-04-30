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
#import "AppDelegate.h"

@implementation CategoryItemCell

@synthesize categoryScrollItem = _categoryScrollItem;
@synthesize categoryTitle = _categoryTitle;
@synthesize parentViewController = _parentViewController;

- (void)dealloc {
    [_categoryScrollItem release];
    [_categoryTitle release];
    [_parentViewController release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andData: (NSDictionary *)dataDict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // TODO: test code
        _categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        _categoryTitle.text = @"Test category title";
        [_categoryTitle setFont:[UIFont systemFontOfSize:CATEGORY_TITLE_FONT_HEIGHT]];
        [self addSubview:_categoryTitle];
        
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
        [_categoryScrollItem.view setFrame:CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT *2, self.frame.size.width, CATEGORY_ITEM_HEIGHT)];
        [self addSubview:_categoryScrollItem.view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)onItemSelected:(int)index
{
    NSLog(@"Category %d selected", index);
    WeiboDetailViewController *weiboDetailController = 
    [[[WeiboDetailViewController alloc] init] autorelease];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboDetailController];
    
    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
    
    [navController release];
//    WeiboComposerViewController *weiboComposerController = 
//    [[[WeiboComposerViewController alloc] initWithNibName:nil bundle:nil] autorelease];
//    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: weiboComposerController];
//    
//    [APPDELEGATE_ROOTVIEW_CONTROLLER presentModalViewController:navController animated:YES];
//    
//    [navController release];
}
@end
