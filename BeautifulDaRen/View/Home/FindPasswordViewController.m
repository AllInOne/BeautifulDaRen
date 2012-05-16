//
//  FindPasswordViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/12/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ButtonViewCell.h"
#import "ViewHelper.h"

@implementation FindPasswordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    [self.navigationItem setTitle:NSLocalizedString(@"find_password", @"find_password")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"帮助"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [[[UITableViewCell alloc] init] autorelease];
        UITextField * textFiled = [[[UITextField alloc] initWithFrame:CGRectMake(20, 10, 300, 40)] autorelease];
        textFiled.placeholder = NSLocalizedString(@"please_input_email_or_account_name", @"please_input_email_or_account_name");
        [cell addSubview:textFiled];
    }
    else if (section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"buttonBackGround"];
        ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"enter", @"enter");
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 1:
        {
            [ViewHelper showSimpleMessage:NSLocalizedString(@"sent_password_to_email", @"sent_password_to_email") withTitle:NSLocalizedString(@"prompt", @"prompt") withButtonText:NSLocalizedString(@"ok_I_know", @"ok_I_know")];
            break;
        }
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
