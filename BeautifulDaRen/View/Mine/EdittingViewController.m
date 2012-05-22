//
//  EdittingViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/22/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "EdittingViewController.h"
#import "ViewHelper.h"
#import "RadioButton.h"

@interface EdittingViewController()

@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) IBOutlet UIView * editNormalView;
@property (retain, nonatomic) IBOutlet UIView * editPrivaceView;

@end

@implementation EdittingViewController
@synthesize inputTextView = _inputTextView;
@synthesize editNormalView = _editNormalView;
@synthesize editPrivaceView = _editPrivaceView;
@synthesize type = _type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)onBackButtonClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onSaveButtonClicked
{
    [ViewHelper showSimpleMessage:@"保存" withTitle:nil withButtonText:@"好的"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSaveButtonClicked) title:NSLocalizedString(@"save", @"save")]];
    if (_type == EdittingViewController_type0) {
        [self.navigationItem setTitle:NSLocalizedString(@"modify", @"modify")];
        _inputTextView.layer.borderColor = [[UIColor grayColor] CGColor];
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.cornerRadius = 5.0;
        [_inputTextView becomeFirstResponder];
        
        [self.view addSubview:_editNormalView];
    }
    else
    {
        [self.navigationItem setTitle:NSLocalizedString(@"privacy", @"privacy")];
        
        NSString * radioButtonGroupId = @"RadioButtonInEdittingView";
        
        RadioButton * radioButton1 = [[[RadioButton alloc] initWithGroupId:radioButtonGroupId text:NSLocalizedString(@"only_to_my_followed", @"") index:0] autorelease];
        RadioButton * radioButton2 = [[[RadioButton alloc] initWithGroupId:radioButtonGroupId text:NSLocalizedString(@"not_to_anyone", @"") index:1] autorelease];
        
        radioButton1.frame = CGRectMake(15, 210, 240, 30);
        radioButton2.frame = CGRectMake(15, 250, 240, 30);
        
        [_editPrivaceView addSubview:radioButton1];
        [_editPrivaceView addSubview:radioButton2];
        
        [self.view addSubview:_editPrivaceView];
    }
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

@end
