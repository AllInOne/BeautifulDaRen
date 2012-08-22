//
//  AgreementViewController.m
//  BeautifulDaRen
//
//  Created by liu gang on 8/22/12.
//
//

#import "AgreementViewController.h"
#import "ViewHelper.h"
#import "BSDKManager.h"
@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"title_help", @"title_help")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back",@"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(backToHomePageButtonClicked) title:NSLocalizedString(@"title_home",@"title_home")]];
    }
    return self;
}

- (void)onBackButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)backToHomePageButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BSDKManager sharedManager] geAgreementAndCallback:^(AIO_STATUS status, NSDictionary *data) {
        NSLog(@"Agreement::::::::::%@",[data description]);
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
