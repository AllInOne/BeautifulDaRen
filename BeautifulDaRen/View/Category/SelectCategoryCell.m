//
//  SelectCategoryCell.m
//  BeautifulDaRen
//
//  Created by jerry.li on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCategoryCell.h"

@interface SelectCategoryCell ()
@property (nonatomic, assign) BOOL isCheckBoxChecked;
@end

@implementation SelectCategoryCell

@synthesize checkBox = _checkBox;
@synthesize textLable = _textLable;
@synthesize isCheckBoxChecked = _isCheckBoxChecked;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        _isCheckBoxChecked  = NO;
//    }
//    return self;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
#pragma mark - View lifecycle
-(void)dealloc
{
    [_textLable release];
    [_checkBox release];
    
    
    [super dealloc];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    self.textLable = nil;
//    self.checkBox = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
