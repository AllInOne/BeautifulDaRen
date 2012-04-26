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

#import "ViewHelper.h"

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
    [self.scrollView setContentSize:CGSizeMake(320, 510)];
    self.registerButton.titleLabel.text = NSLocalizedString(@"register",@"");
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
    return 50;
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
            case 0:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"account_user_account", @"");
                break;
            }
            case 1:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"password", @"");
                break;
            }
            case 2:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"account_register_email", @"");
                break;
            }
            case 3:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"local_city", @"");
                break;
            }
            case 4:
            {
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"my_gender", @"");
                [((AccountInfoInputCell*)cell).segementedController setTitle:NSLocalizedString(@"female", @"") forSegmentAtIndex:0];
                [((AccountInfoInputCell*)cell).segementedController setTitle:NSLocalizedString(@"male", @"") forSegmentAtIndex:1];
                [((AccountInfoInputCell*)cell).segementedController addTarget:self action:@selector(genderChooserAction:) forControlEvents:UIControlEventValueChanged];
                break;
            }
            case 5:
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


@end
