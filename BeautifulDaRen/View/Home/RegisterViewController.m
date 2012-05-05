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
    ACCOUNT_SETTING_USER_ID = 0,
    ACCOUNT_SETTING_PASSWORD,
    ACCOUNT_SETTING_EMAIL,
    ACCOUNT_SETTING_CITY,
    ACCOUNT_SETTING_GENDER,
    ACCOUNT_SETTING_AVATAR
};

#define REGISTER_SCROLL_CONTENT_HEIGHT 440

@interface RegisterViewController()

@property (retain, nonatomic) IBOutlet UITableView * accountInfoTable;
@property (retain, nonatomic) IBOutlet UITableView * loginWithExtenalTable;
@property (retain, nonatomic) IBOutlet UIButton * registerButton;
@property (retain, nonatomic) IBOutlet UILabel * noticeForuseLabel;

@property (retain, nonatomic) IBOutlet UIScrollView * scrollView;
@end

@implementation RegisterViewController
@synthesize accountInfoTable;
@synthesize loginWithExtenalTable;
@synthesize registerButton;
@synthesize noticeForuseLabel;
@synthesize scrollView;

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
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, REGISTER_SCROLL_CONTENT_HEIGHT)];
    self.noticeForuseLabel.text = NSLocalizedString(@"notice_for_use",@"");
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

-(IBAction)registerButtonSelected:(id)sender
{
    // TODO 
    NSLog(@"TO handle register button.");
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
                    index = 0;
                    break;
                case 3:
                    index = 3;
                    break;
                case 4:
                    index = 2;
                    break;
                case 5:
                    index = 1;
                    break;
            }
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:index];
        }
        switch ([indexPath row]) {
            case ACCOUNT_SETTING_USER_ID:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"account_user_account", @"");
                break;
            }
            case ACCOUNT_SETTING_PASSWORD:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"password", @"");
                break;
            }
            case ACCOUNT_SETTING_EMAIL:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"account_register_email", @"");
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"local_city", @"");
                ((AccountInfoInputCell*)cell).secondLabel.text = NSLocalizedString(@"to_select", @"");
                ((AccountInfoInputCell*)cell).imageView.image = [UIImage imageNamed:@"first"];
                break;
            }
            case ACCOUNT_SETTING_GENDER:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"my_gender", @"");
                [((AccountInfoInputCell*)cell).segementedController setTitle:NSLocalizedString(@"female", @"") forSegmentAtIndex:0];
                [((AccountInfoInputCell*)cell).segementedController setTitle:NSLocalizedString(@"male", @"") forSegmentAtIndex:1];
                [((AccountInfoInputCell*)cell).segementedController addTarget:self action:@selector(genderChooserAction:) forControlEvents:UIControlEventValueChanged];
                break;
            }
            case ACCOUNT_SETTING_AVATAR:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"add_avatar", @"");
                ((AccountInfoInputCell*)cell).imageView.image = [UIImage imageNamed:@"first"];
                ((AccountInfoInputCell*)cell).secondLabel.text = NSLocalizedString(@"set_avatar", @"");
                break;
            }
        }
    }
    else if(tableView == self.loginWithExtenalTable)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(tableView == self.accountInfoTable)
    {
        number = 6;
    }
    else if(tableView == self.loginWithExtenalTable)
    {
        number = 2;
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
            case ACCOUNT_SETTING_PASSWORD:
            {
                break;
            }
            case ACCOUNT_SETTING_EMAIL:
            {
                break;
            }
            case ACCOUNT_SETTING_CITY:
            {
                SelectCityViewController *citySelectionController = 
                [[[SelectCityViewController alloc] initWithNibName:nil bundle:nil] autorelease];

                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
                
                if (!SYSTEM_VERSION_LESS_THAN(@"5.0"))
                {
                    [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部背景.png"] forBarMetrics:UIBarMetricsDefault];
                }
                
                [self.navigationController presentModalViewController:navController animated:YES];
                
                [navController release];
                break;
            }
            case ACCOUNT_SETTING_GENDER:
            {
                break;
            }
            case ACCOUNT_SETTING_AVATAR:
            {
                break;
            }
        }
    }
    else if(tableView == self.loginWithExtenalTable)
    {
        if ([indexPath row] == 0) {
            
        }
        else
        {
            [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
                NSLog(@"QZone login done, status:%d", status);
            }];
        
        }
    }    
    
}

@end
