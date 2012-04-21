//
//  CommonScrollViewItem.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonScrollViewItem.h"

@implementation CommonScrollViewItem

@synthesize button;
@synthesize image;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [button release];
    [image release];
    [super dealloc];
}

@end
