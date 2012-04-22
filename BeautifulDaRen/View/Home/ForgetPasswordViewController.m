//
//  ForgetPasswordViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/21/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AccountInfoInputCell.h"

#define FORGET_PASSWORD_ACCOUNT_INFO 0
#define FORGET_PASSWORD_

@implementation ForgetPasswordViewController

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

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * accountInfoCellIdentifier = @"AccountInfoInputCell";
    UITableViewCell * cell = nil;
    switch ([indexPath section]) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:accountInfoCellIdentifier];
            if(!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:accountInfoCellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            if([indexPath row] == 0) {
                ((AccountInfoInputCell*)cell).inputLabel.text =NSLocalizedString(@"account_user_account", @"user_account");
                [((AccountInfoInputCell*)cell).inputLabel setUserInteractionEnabled:YES];
            } else {
                ((AccountInfoInputCell*)cell).inputLabel.text =NSLocalizedString(@"account_register_email", @"register_email");
                [((AccountInfoInputCell*)cell).inputLabel setUserInteractionEnabled:YES];
            }
            break;
            
        default:
            break;
    }
    return cell;
}


#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"title";
}
@end
