//
//  FriendHorizontalScrollView.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/4/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FriendHorizontalScrollView.h"

@interface FriendHorizontalScrollView ()

@end

@implementation FriendHorizontalScrollView
@synthesize friendScrollView = _friendScrollView;
@synthesize friendScrollTitle = _friendScrollTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title: (NSString*)title andData: (NSArray *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _friendScrollView = [[CommonScrollView alloc] initWithNibName:nil bundle:nil data:data andDelegate:self];
        
        [self.view addSubview:_friendScrollView.view];
        
//        _friendScrollView.view.frame = CGRectMake(0, CATEGORY_TITLE_FONT_HEIGHT + CONTENT_MARGIN, self.view.frame.size.width, CATEGORY_ITEM_HEIGHT);
        
        _friendScrollTitle.text = title;
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
    _friendScrollView = nil;
    _friendScrollTitle = nil;
}

-(void)dealloc
{
    [_friendScrollTitle release];
    [_friendScrollView release];
}

- (void)onItemSelected:(int)index
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
