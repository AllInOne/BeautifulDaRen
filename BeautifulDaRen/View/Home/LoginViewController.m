//
//  LoginViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInfoInputCell.h"
#import "ButtonViewCell.h"

#define ACCOUNT_INPUT_SECTION 0
#define ACCOUNT_LOGIN_BUTTON_SECTION 1
#define ACCOUNT_REGITER_SECTION 2
#define ACCOUNT_LOGIN_WITH_EXTENAL 3

@interface LoginViewController()

@property (retain, nonatomic) IBOutlet UITableView * accountInputTable;
@property (retain, nonatomic) IBOutlet UITableView * registerTable;
@property (retain, nonatomic) IBOutlet UITableView * loginWithExtenalTable;
@property (retain, nonatomic) IBOutlet UIButton * loginButton;

- (IBAction)loginButtonSelected:(id)sender;

@end

@implementation LoginViewController
@synthesize accountInputTable;
@synthesize registerTable;
@synthesize loginWithExtenalTable;
@synthesize loginButton;

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

#pragma mark UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (tableView == self.accountInputTable) {
        number = 2;
    }
    else if (tableView == self.registerTable)
    {
        number = 1;
    }
    else if (tableView == self.loginWithExtenalTable)
    {
        number = 2;
    }
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    if(tableView == self.accountInputTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row])
        {
            case 0:
            {
                // "user name"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"user_name", @"user name");
                break;
            }
            case 1:
            {
                // "password"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"password", @"password");
                break;
            }
        }
    }
    else if (tableView == self.registerTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:1];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"not_user_to_register", @"You are not user, please register");
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"first"]; 
    }
    else if (tableView == self.loginWithExtenalTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row]) {
            case 0:
            {
                // sina weibo
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_sina_weibo", @"You are not user, please register");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
                break;
            } 
            case 1:
            {
                // tencent weibo
                ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"login_with_tencent_qq", @"You are not user, please register");
                ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"first"]; 
                ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"second"]; 
                break;
            }
        }
    }
    return cell;
}

#pragma mark LoginViewController
- (IBAction)loginButtonSelected:(id)sender
{
    NSLog(@"TODO loginButtonSelected IN LoginViewController.m");
}


@end
