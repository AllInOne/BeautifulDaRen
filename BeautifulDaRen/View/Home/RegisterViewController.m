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
#import "BSDKDefines.h"

#import "ViewHelper.h"
#import "ViewConstants.h"

typedef enum
{
    ACCOUNT_SETTING_EMAIL = 0,
    ACCOUNT_SETTING_USER_ID,
    ACCOUNT_SETTING_PASSWORD,
    ACCOUNT_SETTING_PASSWORD_AGAIN,
    ACCOUNT_SETTING_CITY
}ACCOUNT_SETTING_FIELD;

typedef enum 
{
    REGISTER_CELL_ACCOUNT_SETTING = 0,
    REGISTER_CELL_REGISTER_BUTTON,
//    REGISTER_CELL_SINA,
    REGISTER_CELL_COUNT
}REGISTER_CELL_INDEX;

#define USER_NAME_TEXT_FIELD @"userNameTextField"
#define USER_EMAIL_TEXT_FIELD @"userEmailTextField"
#define USER_PWD_TEXT_FIELD @"userPwdTextField"
#define USER_REPWD_TEXT_FIELD @"userRePwdTextField"
#define USER_CITY @"userCity"

@interface RegisterViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UITextField * userNameTextField;
@property (retain, nonatomic) IBOutlet UITextField * userEmailTextField;
@property (retain, nonatomic) IBOutlet UITextField * userPwdTextField;
@property (retain, nonatomic) IBOutlet UITextField * userRePwdTextField;
@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;
@property (retain, nonatomic) NSString * userCity;
@property (retain, nonatomic) NSMutableArray* observers;
@property (retain, nonatomic) NSMutableDictionary * savingInputDict;

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
@synthesize savingInputDict = _savingInputDict;
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
    [_savingInputDict release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _savingInputDict = [[NSMutableDictionary alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loginWithQQButton = nil;
    self.loginWithSinaWeiboButton = nil;
    self.tableView = nil;
    self.savingInputDict = nil;
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
    if(section == REGISTER_CELL_ACCOUNT_SETTING)
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
                accountInfoInputCell.inputTextField.text = [self.savingInputDict valueForKey:USER_EMAIL_TEXT_FIELD];
                self.userEmailTextField = nil;
                self.userEmailTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_USER_ID:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"user_name_id", @"");
                accountInfoInputCell.inputLabel.textAlignment = UITextAlignmentLeft;
                accountInfoInputCell.inputTextField.delegate = self;
                
                accountInfoInputCell.inputTextField.placeholder = NSLocalizedString(@"please_input_a_beautifu_daren_name", @"");
                accountInfoInputCell.inputTextField.text = [self.savingInputDict valueForKey:USER_NAME_TEXT_FIELD];
                self.userNameTextField = nil;
                self.userNameTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
                accountInfoInputCell.inputTextField.text = [self.savingInputDict valueForKey:USER_PWD_TEXT_FIELD];
                self.userPwdTextField = nil;
                self.userPwdTextField = accountInfoInputCell.inputTextField;
                break;
            }
            case ACCOUNT_SETTING_PASSWORD_AGAIN:
            {
                accountInfoInputCell.inputLabel.text = NSLocalizedString(@"type_password_again", @"");
                accountInfoInputCell.inputTextField.delegate = self;
                [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
                accountInfoInputCell.inputTextField.text = [self.savingInputDict valueForKey:USER_REPWD_TEXT_FIELD];
                self.userRePwdTextField = nil;
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
    else if (section == REGISTER_CELL_REGISTER_BUTTON)
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
//    else if (section == REGISTER_CELL_SINA)
//    {
//        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
//        self.loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
//        self.loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
//        ((ButtonViewCell*)cell).delegate = self;
//    }
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return REGISTER_CELL_COUNT;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == REGISTER_CELL_ACCOUNT_SETTING)
    {
        number = 5;
    }
    else if(section == REGISTER_CELL_REGISTER_BUTTON)
    {
        number = 1;
    }
//    else if(section == REGISTER_CELL_SINA)
//    {
//        number = 1;
//    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    if(section == REGISTER_CELL_ACCOUNT_SETTING)
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
    else if(section == REGISTER_CELL_REGISTER_BUTTON)
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
        if (!userName || [userName isEqualToString:@""])
        {
            iToastString = NSLocalizedString(@"please_check_username", @"please_check_username");
        }
        else if (!email || [email isEqualToString:@""] || ![ViewHelper NSStringIsValidEmail:email])
        {
            iToastString = NSLocalizedString(@"please_check_email", @"please_check_email");
        }
        else if (!pwd || [pwd isEqualToString:@""])
        {
            iToastString = NSLocalizedString(@"please_check_password", @"please_check_password");
        }
        else if(!rePwd || ![pwd isEqualToString:rePwd])
        {
            iToastString = NSLocalizedString(@"password_not_the_same", @"password_not_the_same");
        }
        else if(!self.userCity || [self.userCity isEqualToString:@""])
        {
            iToastString = NSLocalizedString(@"please_check_city", @"please_check_city");
        }
        if(![iToastString isEqualToString:@""])
        {
            [[iToast makeText:iToastString] show];
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_SHOWWAITOVERLAY object:self];
       [[BSDKManager sharedManager]
        signUpWithUsername:userName
        password:pwd
        email:email
        city:self.userCity
        andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_HIDEWAITOVERLAY object:self];
            if(AIO_STATUS_SUCCESS == status && K_BSDK_IS_RESPONSE_OK(data))
            {
                NSDictionary * dict = [data objectForKey:K_BSDK_USERINFO];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:K_NOTIFICATION_LOGIN_SUCCESS object:self userInfo:data];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:USERDEFAULT_IS_AUTO_LOGIN];
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:USERDEFAULT_AUTO_LOGIN_ACCOUNT_PASSWORD];
            }
            else
            {
                [[iToast makeText:[NSString stringWithFormat:@"%@", K_BSDK_GET_RESPONSE_MESSAGE(data)]] show];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 3;
    if(section == REGISTER_CELL_ACCOUNT_SETTING)
    {
        height = 10;
    }
//    else if (section == REGISTER_CELL_SINA) {
//        height = 25;
//    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
//    if(section == REGISTER_CELL_SINA)
//    {
//        view = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHeaderView" owner:self options:nil] objectAtIndex:0];
//        UILabel * label = (UILabel*)[view viewWithTag:1];
//        label.textColor = [UIColor darkGrayColor];
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * key = nil;
    if (textField == self.userEmailTextField)
    {
        key = USER_EMAIL_TEXT_FIELD;
    }
    else if(textField == self.userNameTextField)
    {
        key = USER_NAME_TEXT_FIELD;
    }
    else if(textField == self.userPwdTextField)
    {
        key = USER_PWD_TEXT_FIELD;
    }
    else if(textField == self.userRePwdTextField)
    {
        key = USER_REPWD_TEXT_FIELD;
    }
    [self.savingInputDict setValue:textField.text forKey:key];
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
                    [[iToast makeText:@"亲，认证成功了哦！"] show];
                }
                else
                {
                    [[iToast makeText:@"亲，认证失败了哦！"] show];
                }
            }];   
        }
        else
        {
            [[iToast makeText:@"亲，已经认证过了哦！"] show];
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
    [self.savingInputDict setValue:city forKey:USER_CITY];
    [self.tableView reloadData];
}

@end
