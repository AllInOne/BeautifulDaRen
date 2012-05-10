//
//  RegisterViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/26/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "RegisterViewController.h"
#import "AccountInfoInputCell.h"
#import "ButtonViewCell.h"
#import "QZoneSDKManager.h"
#import "SelectCityViewController.h"

#import "ViewHelper.h"
#import "ViewConstants.h"

enum
{
    ACCOUNT_SETTING_EMAIL = 0,
    ACCOUNT_SETTING_USER_ID,
    ACCOUNT_SETTING_PASSWORD,
    ACCOUNT_SETTING_PASSWORD_AGAIN,
    ACCOUNT_SETTING_CITY
};

#define REGISTER_SCROLL_CONTENT_HEIGHT 440

@interface RegisterViewController()

@property (retain, nonatomic) IBOutlet UITableView * accountInfoTable;
@property (retain, nonatomic) IBOutlet UITableView * loginWithExtenalTable;
@property (retain, nonatomic) IBOutlet UIButton * registerButton;
@property (retain, nonatomic) IBOutlet UIButton * noticeForUseButton;

@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;

@property (retain, nonatomic) IBOutlet UIScrollView * scrollView;

@end

@implementation RegisterViewController

@synthesize accountInfoTable;
@synthesize loginWithExtenalTable;
@synthesize registerButton;
@synthesize noticeForUseButton;
@synthesize scrollView;

@synthesize loginWithQQButton;
@synthesize loginWithSinaWeiboButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, REGISTER_SCROLL_CONTENT_HEIGHT)];
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

#pragma mark Action

-(IBAction)registerButtonSelected:(id)sender
{
    // TODO 
    NSLog(@"TO handle register button.");
}

-(IBAction)noticeForUseSelected:(id)sender
{
    // TODO
    NSLog(@"TO handle notice for use button.");
}

-(void) genderChooserAction: (UISegmentedControl*)seg
{
    // TODO
    NSLog(@"TO handle segmented control");
}
#pragma mark UITableViewDelegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark UITableViewDataSource
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell";
    UITableViewCell * cell;
    if(tableView == self.accountInfoTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            NSInteger index = 0;
            switch ([indexPath row]) {
                case 0:
                case 1:
                case 2:
                case 3:
                    index = 0;
                    break;
                case 4:
                    index = 3;
                    break;
            }
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:index];
        }
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_EMAIL:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"account_register_email", @"");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_USER_ID:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"user_name_id", @"");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"type_password", @"");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"type_password_again", @"");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"local_city", @"");
                ((AccountInfoInputCell*)cell).secondLabel.text = NSLocalizedString(@"to_select", @"");
                ((AccountInfoInputCell*)cell).imageView.image = [UIImage imageNamed:@"first"];
                break;
            }
        }
    }
    else if (tableView == self.loginWithExtenalTable)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
        self.loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
        self.loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
        ((ButtonViewCell*)cell).delegate = self;
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(tableView == self.accountInfoTable)
    {
        number = 5;
    }
    else if(tableView == self.loginWithExtenalTable)
    {
        number = 1;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.accountInfoTable)
    {
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_USER_ID:
            {
                break;
            }
            case ACCOUNT_SETTING_EMAIL:
            {
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                SelectCityViewController *citySelectionController = 
                [[[SelectCityViewController alloc] initWithNibName:nil bundle:nil] autorelease];

                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
                
                [self.navigationController presentModalViewController:navController animated:YES];
                
                [navController release];
                break;
            }
        }
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ButtonPressDelegate
- (void)didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    if(button ==  self.loginWithSinaWeiboButton)
    {
        NSLog(@"loginWithSinaWeiboButton");
    }
    else if(button == self.loginWithQQButton)
    {
        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"QZone login done, status:%d", status);
        }];
    }
}

@end
