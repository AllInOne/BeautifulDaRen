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
@property (assign , nonatomic) IBOutlet UITextView *textView;
@end

@implementation AgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"title_agreement", @"title_agreement")];
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
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.frame = CGRectMake((self.view.frame.size.width - activityIndicator.frame.size.width) / 2,
                                         15,
                                         activityIndicator.frame.size.width,
                                         activityIndicator.frame.size.height);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[BSDKManager sharedManager] geAgreementAndCallback:^(AIO_STATUS status, NSDictionary *data)
     {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [activityIndicator release];
        self.textView.text = [data valueForKey:@"msg"];
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
