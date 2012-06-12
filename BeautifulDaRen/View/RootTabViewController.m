//
//  RootTabViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootTabViewController.h"
#import "ViewConstants.h"
#import "CustomUITabBarItem.h"
#import "BSDKManager.h"
#import "ViewConstants.h"

@interface RootTabViewController()
- (void)initLocalizedString;
@end

@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"nav_bar_background"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@implementation RootTabViewController

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self initLocalizedString];

    if (!SYSTEM_VERSION_LESS_THAN(@"5.0"))
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_background"] forBarMetrics:UIBarMetricsDefault];

        [[UIToolbar appearance]setBackgroundImage:[UIImage imageNamed:@"toolbar_background"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }
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

#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![[BSDKManager sharedManager] isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOULD_LOGIN object:self];
        return NO;
    }
    return YES;
}

- (void)initLocalizedString
{
    NSArray* homeArray = [NSArray arrayWithObjects:@"",NSLocalizedString(@"tab_home", @"tab_home"),nil];
    NSArray* mineArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_mine", @"tab_mine"),NSLocalizedString(@"tab_mine", @"tab_mine"),nil];
    NSArray* cameraShareArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_myshow", @"tab_myshow"),NSLocalizedString(@"tab_myshow", @"tab_myshow"),nil];
    NSArray* categoryArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_hot", @"tab_hot"),NSLocalizedString(@"tab_hot", @"tab_hot"),nil];
    NSArray* moreArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_search", @"tab_search"), NSLocalizedString(@"tab_search", @"tab_search"),nil];
    NSArray* localizedStringsArray = [NSArray arrayWithObjects:homeArray, mineArray, cameraShareArray, categoryArray, moreArray, nil];
    
    NSArray* tabbarIconNamesArray = [NSArray arrayWithObjects:@"tabbar_home_icon", @"tabbar_mine_icon", @"tabbar_show_icon", @"tabbar_hot_icon", @"tabbar_search_icon", nil];
    
    NSInteger index = 0;
    for (UINavigationController* navigation in [self customizableViewControllers]){
        UINavigationItem* navigationItem = navigation.topViewController.navigationItem;
        NSArray* textArray = [localizedStringsArray objectAtIndex:index];
        [navigationItem setTitle:[textArray objectAtIndex:0]];
        
        CustomUITabBarItem * tempTabBarItem = [[CustomUITabBarItem alloc] initWithTitle:[textArray objectAtIndex:1] normalImage:[UIImage imageNamed:[tabbarIconNamesArray objectAtIndex:index]] highlightedImage:[UIImage imageNamed:[tabbarIconNamesArray objectAtIndex:index]] tag:index];
        navigation.tabBarItem = tempTabBarItem;
        [tempTabBarItem release];
        index++;
    }

    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_background"]];
        tabBarBg.frame = CGRectMake(0, 0, 320, 50);
        tabBarBg.contentMode = UIViewContentModeScaleToFill;
        
        [self.tabBar insertSubview:tabBarBg atIndex:0];
        [tabBarBg release];
    }
    else
    {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    }
}

@end
