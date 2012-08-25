//
//  LoginViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInfoInputCell.h"
#import "RegisterViewController.h"
#import "ButtonViewCell.h"
#import "SinaSDKManager.h"
#import "QZoneSDKManager.h"
#import "FindPasswordViewController.h"
#import "iToast.h"
#import "BSDKManager.h"
#import "BSDKDefines.h"
#import "ViewConstants.h"
#import "ViewHelper.h"
#import "iToast.h"

typedef enum
{
    LOGIN_CELL_USERNAME_PASSWORD = 0,
    LOGIN_CELL_LOGIN_BUTTON,
    LOGIN_CELL_REGISTER,
//    LOGIN_CELL_SINA_LOGIN,
    LOGIN_CELL_COUNT
}LOGIN_CELL_INDEX;

@interface LoginViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UITextField * accountNameField;
@property (retain, nonatomic) IBOutlet UITextField * accountPwdField;
@property (retain, nonatomic)  NSMutableArray* observers;

@end

@implementation LoginViewController
@synthesize tableView = _tableView;
@synthesize loginWithQQButton =_loginWithQQButton;
@synthesize loginWithSinaWeiboButton = _loginWithSinaWeiboButton;
@synthesize accountNameField = _accountNameField;
@synthesize accountPwdField = _accountPwdField;
@synthesize observers = _observers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"login", @"login")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onFindPasswordButtonClicked) title:NSLocalizedString(@"find_password", @"find_password")]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)onSinaLoginButtonPressed:(id)sender
{
    [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"Sina SDK login done, status:%d", status);
    }];
}

-(IBAction)onTencentLoginButtonPressed:(id)sender
{
    [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"QZone SDK login done, status:%d", status);
    }];
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void) onFindPasswordButtonClicked
{
    FindPasswordViewController * findPasswordViewController = [[FindPasswordViewController alloc] initWithNibName:@"FindPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
    [findPasswordViewController release];
}

#pragma mark - View lifecycle

-(void)dealloc
{
    [_tableView release];
    [_loginWithQQButton release];
    [_loginWithSinaWeiboButton release];
    [_accountNameField release];
    [_accountPwdField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loginWithQQButton = nil;
    self.loginWithSinaWeiboButton = nil;
    self.tableView = nil;
    self.accountNameField = nil;
    self.accountPwdField = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
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
    [super viewWillDisappear:animated];
    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    [self.observers removeAllObjects];
    self.observers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case LOGIN_CELL_USERNAME_PASSWORD:
        {
            number = 2;
            break;
        }   
        case LOGIN_CELL_LOGIN_BUTTON:
        case LOGIN_CELL_REGISTER:
//        case LOGIN_CELL_SINA_LOGIN:
        {
            number = 1;
            break;
        }
    }
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return LOGIN_CELL_COUNT;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell0";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == LOGIN_CELL_USERNAME_PASSWORD)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountInfoInputCell" owner:self options:nil] objectAtIndex:0];
        }
        AccountInfoInputCell * accountInfoInputCell = ((AccountInfoInputCell*)cell);
        switch ([indexPath row])
        {
            case 0:
            {
                // "user name"
                accountInfoInputCell.inputLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"account", @"account")];
                accountInfoInputCell.inputTextField.delegate = self;
                [accountInfoInputCell.inputTextField setPlaceholder:NSLocalizedString(@"email_or_nickname", @"email_or_nickname")];
                self.accountNameField = accountInfoInputCell.inputTextField;
                break;
            }
            case 1:
            {
                // "password"
                accountInfoInputCell.inputLabel.text =[NSString stringWithFormat:@"%@：", NSLocalizedString(@"password", @"password")];
                [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
                accountInfoInputCell.inputTextField.delegate = self;
                self.accountPwdField = accountInfoInputCell.inputTextField;
                break;
            }
        }
    }
    else if(section == LOGIN_CELL_LOGIN_BUTTON)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"login_button"];
        ((ButtonViewCell*)cell).buttonLeftIconPressed = [UIImage imageNamed:@"login_button_pressed"];
        ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"login", @"login");
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else if (section == LOGIN_CELL_REGISTER)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:1];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"not_user_to_register", @"You are not user, please register");
    }
//    else if (section == LOGIN_CELL_SINA_LOGIN)
//    {
//        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
//        _loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
//        _loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
//        ((ButtonViewCell*)cell).delegate = self;
//    }
    return cell;
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == LOGIN_CELL_LOGIN_BUTTON) {
        __block NSString* userName = self.accountNameField.text;
        __block NSString* password = self.accountPwdField.text;
<<<<<<< HEAD
#ifdef DEBUG        
        userName = @"tankliu002";
        password = @"abc123456";
=======
#ifdef DEBUG
        if ((userName == nil) && (password == nil)) {
            userName = @"jerry888";
            password = @"210140";
        }
>>>>>>> fe9ad9bf14dabf31587a315cd1f788f23bcac8bc
#endif
        NSString * iToastString = @"";
        if ([userName isEqualToString:@""])
        {
            iToastString = @"亲, 用户名不能为空哦!";
        }
        else if ([password isEqualToString:@""])
        {
            iToastString = @"亲, 密码不能为空哦!";
        }
        if(![iToastString isEqualToString:@""])
        {
            [[iToast makeText:iToastString] show];
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
        [[BSDKManager sharedManager] loginWithUsername:userName
                                              password:password
                                       andDoneCallback:^(AIO_STATUS status, NSDictionary *data)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
             if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
             {
                 
                 NSDictionary * dict = [data objectForKey:K_BSDK_USERINFO];
                 [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                 if(![self.navigationController popToRootViewControllerAnimated:YES])
                 {
                     [self dismissModalViewControllerAnimated:YES];
                 }
                 [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
                 
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:USERDEFAULT_IS_AUTO_LOGIN];
                 [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_NAME];
                 [[NSUserDefaults standardUserDefaults] setObject:password forKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_PASSWORD];
             }
             else
             {
                 [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
             }
         }];
    }
    else if([indexPath section] == LOGIN_CELL_REGISTER)
    {
        RegisterViewController * registerController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        [self.navigationController pushViewController:registerController animated:YES];
        [registerController release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 3;
    if(section == LOGIN_CELL_USERNAME_PASSWORD)
    {
        height = 10;
    }
//    else if (section == LOGIN_CELL_SINA_LOGIN ) {
//        height = 25;
//    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
//    if(section == LOGIN_CELL_SINA_LOGIN)
//    {
//        view = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHeaderView" owner:self options:nil] objectAtIndex:0];
//        UILabel * label = (UILabel*)[view viewWithTag:1];
//        [label setTextColor:[UIColor darkGrayColor]];
//        label.text = NSLocalizedString(@"login_with_cooperation", @"login_with_cooperation");
//    }
//    else
    {
        view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
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
        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"QZone login done, status:%d", status);
        }];
    }
}

@end
