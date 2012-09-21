//
//  FindPasswordViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/12/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ButtonViewCell.h"
#import "HelpViewController.h"
#import "ViewHelper.h"
#import "iToast.h"
#import "BSDKManager.h"

@interface FindPasswordViewController()
@property (retain, nonatomic) UITextField *userNameTextField;
@property (retain, nonatomic) UITextField *userEmailTextField;
@end

@implementation FindPasswordViewController
@synthesize userEmailTextField = _userEmailTextField;
@synthesize userNameTextField = _userNameTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"find_password", @"find_password")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onHelpButtonClicked) title:NSLocalizedString(@"title_help", @"title_help")]];
}

- (void)dealloc
{
    [super dealloc];

    [_userNameTextField release];
    [_userEmailTextField release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];

    self.userNameTextField = nil;
    self.userEmailTextField = nil;
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

- (void)onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)onHelpButtonClicked
{
    HelpViewController * helpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpViewController animated:YES];
    [helpViewController release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 1;
    if (section == 0) {
        number = 2;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [[[UITableViewCell alloc] init] autorelease];
        UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 300, 40)];
        if ([indexPath row] == 0)
        {
            textFiled.placeholder = NSLocalizedString(@"please_input_account_name", @"please_input_account_name");
            self.userNameTextField = textFiled;
        }
        else if ([indexPath row] == 1)
        {
            textFiled.placeholder = NSLocalizedString(@"please_input_account_email", @"please_input_account_email");
            self.userEmailTextField = textFiled;
        }
        [cell addSubview:textFiled];
        [textFiled release];
    }
    else if (section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"login_button"];
        ((ButtonViewCell*)cell).buttonLeftIconPressed = [UIImage imageNamed:@"login_button_pressed"];
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
            if ([self.userNameTextField.text length] <= 0)
            {
                [[iToast makeText:@"请输入登陆账号!"] show];
                break;
            }
            else if ([self.userEmailTextField.text length] <= 0)
            {
                [[iToast makeText:@"请输入注册邮箱!"] show];
                break;
            }
            [[BSDKManager sharedManager] findPasswordOfUserName:self.userNameTextField.text
                                                          email:self.userEmailTextField.text
                                                    andCallBack:^(AIO_STATUS status, NSDictionary *data)
             {
                 [[iToast makeText:[data valueForKey:@"msg"]] show];
            }];
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
