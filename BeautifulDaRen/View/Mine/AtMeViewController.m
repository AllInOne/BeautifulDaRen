//
//  AtMeViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/14/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "AtMeViewController.h"
#import "AtMeViewCell.h"
#import "ViewHelper.h"

@interface AtMeViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;

@end

@implementation AtMeViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"@me", @"@me")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:nil title:@"XXX"]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:nil title:@"图片模式"]];
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

#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  130;
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * atMeViewCellIdentifier = @"AtMeViewCell";
    UITableViewCell * cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:atMeViewCellIdentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:atMeViewCellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    ((AtMeViewCell*)cell).friendNameLabel.text = @"仁和春天光华店";
    ((AtMeViewCell*)cell).shopNameLabel.text = @"仁和春天";
    ((AtMeViewCell*)cell).brandLabel.text = @"好莱坞明星";
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
@end
