//
//  RootTabViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootTabViewController.h"
#import "ViewConstants.h"

@interface RootTabViewController()
- (void)initLocalizedString;
@end

@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    NSLog(@"%f:%f", self.frame.size.width, self.frame.size.height);
    UIImage *image = [UIImage imageNamed: @"顶部背景.png"];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)initLocalizedString
{
    NSArray* homeArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_home", @""),NSLocalizedString(@"title_home", @""),nil];
    NSArray* mineArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_mine", @""),NSLocalizedString(@"title_mine", @""),nil];
    NSArray* cameraShareArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_camerashare", @""),NSLocalizedString(@"title_camerashare", @""),nil];
    NSArray* categoryArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_category", @""),NSLocalizedString(@"title_category", @""),nil];
    NSArray* moreArray = [NSArray arrayWithObjects:NSLocalizedString(@"tab_more", @""), NSLocalizedString(@"title_more", @""),nil];
    NSArray* localizedStringsArray = [NSArray arrayWithObjects:homeArray, mineArray, cameraShareArray, categoryArray, moreArray, nil];
    
    NSInteger index = 0;
    for (UINavigationController* navigation in [self customizableViewControllers]){
        UINavigationItem* navigationItem = navigation.topViewController.navigationItem;
        NSArray* textArray = [localizedStringsArray objectAtIndex:index++];
        [navigationItem setTitle:[textArray objectAtIndex:0]];
        navigation.tabBarItem.title = [textArray objectAtIndex:1];
        
        if (!SYSTEM_VERSION_LESS_THAN(@"5.0"))
        {
            [navigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部背景"] forBarMetrics:UIBarMetricsDefault];
        }
    }

    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        UIImageView * tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"底部背景.png"]];
        tabBarBg.frame = CGRectMake(0, 0, 320, 50);
        tabBarBg.contentMode = UIViewContentModeScaleToFill;
        
        [self.tabBar insertSubview:tabBarBg atIndex:0];    
    }
    else
    {
// Open it when the Ux image is resized to small ones
//        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"底部背景.png"]];
    }
}

@end
