//
//  ModifyPasswordViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 6/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "AccountInfoInputCell.h"
#import "ButtonViewCell.h"
#import "ViewHelper.h"
#import "BSDKManager.h"
#import "iToast.h"
#import "ViewConstants.h"

@interface ModifyPasswordViewController ()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UITextField * oldPasswordField;
@property (retain, nonatomic) IBOutlet UITextField * resetPasswordField;
@property (retain, nonatomic) IBOutlet UITextField * repeatNewPasswordField;

@end

@implementation ModifyPasswordViewController
@synthesize tableView = _tableView;
@synthesize oldPasswordField = _oldPasswordField;
@synthesize resetPasswordField = _resetPasswordField;
@synthesize repeatNewPasswordField = _repeatNewPasswordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"modify_password", @"modify_password")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
}

- (void)onBackButtonClicked {
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * accountInfoInputCellIdentifier = @"AccountInfoInputCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    if ([indexPath section] == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:accountInfoInputCellIdentifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:accountInfoInputCellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        AccountInfoInputCell * accountInfoInputCell = (AccountInfoInputCell*)cell;
        if ([indexPath row] == 0)
        {
            accountInfoInputCell.inputLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"old_passwrod", @"old_passwrod")];
            accountInfoInputCell.inputTextField.delegate = self;
            [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
            [accountInfoInputCell.inputTextField setPlaceholder:NSLocalizedString(@"input_your_old_password", @"input_your_old_password")];
            self.oldPasswordField = accountInfoInputCell.inputTextField;
        }
        else if ([indexPath row] == 1)
        {
            accountInfoInputCell.inputLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"new_passwrod", @"new_passwrod")];
            accountInfoInputCell.inputTextField.delegate = self;
            [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
            [accountInfoInputCell.inputTextField setPlaceholder:NSLocalizedString(@"input_your_new_password", @"input_your_new_password")];
            self.resetPasswordField = accountInfoInputCell.inputTextField;
        }
        else if ([indexPath row] == 2)
        {
            accountInfoInputCell.inputLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"new_passwrod", @"new_passwrod")];
            accountInfoInputCell.inputTextField.delegate = self;
            [accountInfoInputCell.inputTextField setSecureTextEntry:YES];
            [accountInfoInputCell.inputTextField setPlaceholder:NSLocalizedString(@"repeat_your_old_password", @"repeat_your_old_password")];
            self.repeatNewPasswordField = accountInfoInputCell.inputTextField;
        }
    }
    else {
        
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == 0)
    {
        number = 3;
    }
    else if (section == 1)
    {
        number = 1;
    }
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1)
    {
        NSString * iToastString = @"";
        if ([self.oldPasswordField.text isEqualToString:@""])
        {
            iToastString = @"旧密码不能为空!";
        }
        else if ([self.resetPasswordField.text isEqualToString:@""])
        {
            iToastString = @"新密码不能为空!";
        }
        else if ([self.resetPasswordField.text isEqualToString:@""])
        {
            iToastString = @"请再次输入新密码!";
        }
        else if (![self.repeatNewPasswordField.text isEqualToString:self.resetPasswordField.text])
        {
            iToastString = @"两次输入新密码不一致!";
        }
        if(![iToastString isEqualToString:@""])
        {
            [[iToast makeText:iToastString] show];
            return;
        }
        
        NSString * accountName = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO] valueForKey:USERDEFAULT_ACCOUNT_USERNAME];
        [[BSDKManager sharedManager] changePasswordByUsername:accountName
                                                  oldPassword:self.oldPasswordField.text
                                                toNewPassword:self.resetPasswordField.text
                                              andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                                  
                                              }];
    }
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
