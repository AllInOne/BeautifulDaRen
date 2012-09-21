//
//  CategoryItemViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryItemViewController.h"

#define ITEM_VIEW_WIDTH  (145.0)
#define ITEM_VIEW_HEIGTH  (46.0)

#define RADIO_CENTER_X  (36.0)
#define RADIO_CENTER_Y  (23.0)
#define RADIO_SIZE  (22.0)

#define MARGIN_RAIDO_TEXT  (10.0)

#define TEXT_X_OFFSET  (16.0)
#define TEXT_Y_OFFSET  (23.0)
#define TEXT_WIDTH  (80.0)
#define TEXT_HEIGHT  (30.0)

@interface CategoryItemViewController ()
@property (nonatomic, assign) BOOL isCheckBoxChecked;
@end

@implementation CategoryItemViewController

@synthesize radioImage = _radioImage;
@synthesize textLable = _textLable;
@synthesize isCheckBoxChecked = _isCheckBoxChecked;
@synthesize cellButton = _cellButton;
@synthesize delegate = _delegate;

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

- (void)dealloc
{
    [_radioImage release];
    [_cellButton release];
    [_textLable release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.frame = CGRectMake(0.0, 0.0, ITEM_VIEW_WIDTH, ITEM_VIEW_HEIGTH);
    self.cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cellButton.frame = CGRectMake(0.0, 0.0, ITEM_VIEW_WIDTH, ITEM_VIEW_HEIGTH);
    [_cellButton setBackgroundImage:[UIImage imageNamed:@"myshow_category_background" ]forState:UIControlStateNormal];
    [_cellButton addTarget:self action:@selector(onItemButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_cellButton];

    _radioImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_btn_unselected"]];
    self.radioImage.center = CGPointMake(RADIO_CENTER_X, RADIO_CENTER_Y);

    [self.view addSubview:_radioImage];

    _textLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.radioImage.frame) + MARGIN_RAIDO_TEXT,
                                                            (ITEM_VIEW_HEIGTH - TEXT_HEIGHT)/2,
                                                            TEXT_WIDTH,
                                                            TEXT_HEIGHT)];
    [self.view addSubview:_textLable];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.radioImage = nil;
    self.cellButton = nil;
    self.textLable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onItemButtonPressed
{
    if (self.delegate) {
        [self.delegate onCheckBoxPressed:self.cellButton];
    }
}
@end
