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
#import "SinaSDKManager.h"
#import "SelectCityViewController.h"
#import "iToast.h"
#import "BSDKManager.h"

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

@interface RegisterViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UITextField * userNameTextField;
@property (retain, nonatomic) IBOutlet UITextField * userEmailTextField;
@property (retain, nonatomic) IBOutlet UITextField * userPwdTextField;
@property (retain, nonatomic) IBOutlet UITextField * userRePwdTextField;
@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;
@property (retain, nonatomic) NSString * userCity;
@property (retain, nonatomic)  NSMutableArray* observers;

@end

@implementation RegisterViewController
@synthesize userEmailTextField = _userEmailTextField;
@synthesize userPwdTextField = _userPwdTextField;
@synthesize userRePwdTextField = _userRePwdTextField;
@synthesize userCity = _userCity;
@synthesize userNameTextField = _userNameTextField;
@synthesize tableView = _tableView;
@synthesize loginWithQQButton = _loginWithQQButton;
@synthesize loginWithSinaWeiboButton = _loginWithSinaWeiboButton;
@synthesize observers = _observers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"register", @"register")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
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
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [_tableView release];
    [_loginWithQQButton release];
    [_loginWithSinaWeiboButton release];
    [_observers release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loginWithQQButton = nil;
    self.loginWithSinaWeiboButton = nil;
    self.tableView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.observers = [NSMutableArray arrayWithCapacity:2];
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                                    object:nil
                                                                     queue:nil
                                                                usingBlock:^(NSNotification * notification){
                                                                    [ViewHelper handleKeyboardDidShow:notification
                                                                                             rootView:self.view
                                                                                            inputView:self.inputView
                                                                                           scrollView:self.tableView];
                                                                }];
    [self.observers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                                 object:nil
                                                                  queue:nil
                                                             usingBlock:^(NSNotification * notification){
                                                                 [ViewHelper handleKeyboardWillBeHidden:self.tableView];
                                                             }];
    [self.observers addObject:observer];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    self.observers = nil;
    [super viewWillDisappear:animated];
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

#pragma mark UITableViewDataSource
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier0 = @"AccountInfoInputCell0";
    static NSString * account_input_identifier3 = @"AccountInfoInputCell3";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        NSInteger index = 0;
        switch ([indexPath row]) {
            case 0:
            case 1:
            case 2:
            case 3:
                index = 0;
                cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier0];
                break;
            case 4:
                index = 3;
                cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier3];
                break;
        }
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountInfoInputCell" owner:self options:nil] objectAtIndex:index];
        }
        AccountInfoInputCell * accountInfoInputCell = ((AccountInfoInputCell*)cell);
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_EMAIL:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"account_register_email", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                accountInfoInputCell.inputTextField.placeholder = NSLocalizedString(@"please_input_your_common_email", @"");
                self.userEmailTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_USER_ID:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"user_name_id", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                
                accountInfoInputCell.inputTextField.placeholder = NSLocalizedString(@"please_input_a_beautifu_daren_name", @"");
                self.userNameTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
                self.userPwdTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password_again", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
                self.userRePwdTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"local_city", @"");
                NSString * cityLabelText = self.userCity;
                if([self.userCity length] <= 0)
                {
                    cityLabelText = NSLocalizedString(@"to_select", @"");
                }
                accountInfoInputCell.secondLabel.text = cityLabelText;
                break;
            }
        }
    }
    else if (section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"login_button"];
        ((ButtonViewCell*)cell).buttonLeftIconPressed = [UIImage imageNamed:@"login_button_pressed"];
        ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"register", @"register");
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else if (section == 2)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
        self.loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
        self.loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
        ((ButtonViewCell*)cell).delegate = self;
    }
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == 0)
    {
        number = 5;
    }
    else if(section == 1)
    {
        number = 1;
    }
    else if(section == 2)
    {
        number = 1;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_CITY:
            {
                SelectCityViewController *citySelectionController = 
                [[SelectCityViewController alloc] initWithNibName:nil bundle:nil];
                citySelectionController.delegate = self;

                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
                
                [self.navigationController presentModalViewController:navController animated:YES];
                
                [navController release];
                [citySelectionController release];
                break;
            }
        }
    }
    else if(section == 1)
    {
        NSString * userName = self.userNameTextField.text;
        NSString * email = self.userEmailTextField.text;
        NSString * pwd = self.userPwdTextField.text;
        NSString * rePwd = self.userRePwdTextField.text;

#ifdef DEBUG
        userName = @"jerry888";
        email = @"12121aa41@11sd.com";
        pwd = @"123456";
        rePwd = @"123456";
        self.userCity = @"重庆"; 
#endif
        NSString * iToastString = @"";
        if ([userName isEqualToString:@""])
        {
            iToastString = @"用户名不能为空!";
        }
        else if ([email isEqualToString:@""])
        {
            iToastString = @"邮箱不能为空!";
        }
        else if ([pwd isEqualToString:@""])
        {
            iToastString = @"密码不能为空!";
        }
        else if(![pwd isEqualToString:rePwd])
        {
            iToastString = @"两次密码输入不一致!";
        }
        else if(!self.userCity || [self.userCity isEqualToString:@""])
        {
            iToastString = @"请选择城市!";
        }
        if(![iToastString isEqualToString:@""])
        {
            [[iToast makeText:iToastString] show];
            return;
        }
       [[BSDKManager sharedManager]
        signUpWithUsername:userName
        password:pwd
        email:email
        city:self.userCity
        andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            if (status == AIO_STATUS_SUCCESS && [[data valueForKey:@"status"]isEqualToString:@"y"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
            }
            else
            {
                [[iToast makeText:[NSString stringWithFormat:@"%@", [data objectForKey:@"msg"]]] show];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 3;
    if(section == 0)
    {
        height = 10;
    }
    else if (section == 2) {
        height = 25;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if(section == 2)
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHeaderView" owner:self options:nil] objectAtIndex:0];
        UILabel * label = (UILabel*)[view viewWithTag:1];
        label.textColor = [UIColor darkGrayColor];
        label.text = NSLocalizedString(@"login_with_cooperation", @"login_with_cooperation");
    }
    else
    {
        view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
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
        if (![[SinaSDKManager sharedManager] isLogin])
        {
            [[SinaSDKManager sharedManager] setRootviewController:self.navigationController];
            [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
                NSLog(@"Sina SDK login done, status:%d", status);
                if (status == LOGIN_STATUS_SUCCESS) {
                    [[iToast makeText:@"亲，认证成功了！"] show];
                }
                else
                {
                    [[iToast makeText:@"亲，认证失败了！"] show];
                }
            }];   
        }
        else
        {
            [[iToast makeText:@"亲，已经认证过了！"] show];
        }
    }
    else if(button == self.loginWithQQButton)
    {
//        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
//            NSLog(@"QZone login done, status:%d", status);
//        }];
    }
}

#pragma mark SelectCityProtocol
- (void)onCitySelected:(NSString*)city
{
    self.userCity = city;
    [self.tableView reloadData];
}

@end
