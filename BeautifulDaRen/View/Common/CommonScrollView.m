//
//  CommonScrollView.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonScrollView.h"

@implementation CommonScrollView

@synthesize scrollTitle = _scrollTitle;
@synthesize scrollView = _scrollView;

- (void)dealloc
{
    [_scrollView release];
    [_scrollTitle release];
    [super release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImageView * imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_icon.png"]];
        imageView1.frame = CGRectMake(0, self.view.frame.origin.y, 38,38);
//        [imageView1 setCenter:center];
        [self.scrollView setContentSize:CGSizeMake(320, 38)];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView addSubview:imageView1];
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
    // Do any additional setup after loading the view from its nib.
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
