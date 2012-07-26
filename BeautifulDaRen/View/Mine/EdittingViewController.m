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
#import "SegmentControl.h"

@interface EdittingViewController()

@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) IBOutlet UIView * editNormalView;
@property (retain, nonatomic) IBOutlet UIView * editPrivaceView;
@property (retain, nonatomic) IBOutlet SegmentControl * commentMeSegmentControl;
@property (retain, nonatomic) IBOutlet SegmentControl * atMeSegmentControl;
@property (retain, nonatomic) IBOutlet SegmentControl * privateLetterMeSegmentControl;
@property (assign, nonatomic) EditDoneBlock callBack;

@end

@implementation EdittingViewController
@synthesize inputTextView = _inputTextView;
@synthesize editNormalView = _editNormalView;
@synthesize editPrivaceView = _editPrivaceView;
@synthesize commentMeSegmentControl = _commentMeSegmentControl;
@synthesize atMeSegmentControl = _atMeSegmentControl;
@synthesize privateLetterMeSegmentControl = _privateLetterMeSegmentControl;
@synthesize type = _type;
@synthesize callBack = _callBack;
@synthesize placeholderString = _placeholderString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type block:(EditDoneBlock)callback
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _type = type;
        [_inputTextView setKeyboardType:UIKeyboardTypeNumberPad];
        _callBack = Block_copy(callback);
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
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)onSaveButtonClicked
{
    if (![self.navigationController popViewControllerAnimated:YES])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    self.callBack(self.inputTextView.text);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSaveButtonClicked) title:NSLocalizedString(@"enter", @"enter")]];
    if (_type == EdittingViewController_type0) {
        [self.navigationItem setTitle:NSLocalizedString(@"modify", @"modify")];
        _inputTextView.layer.borderColor = [[UIColor grayColor] CGColor];
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.cornerRadius = 5.0;
        [_inputTextView becomeFirstResponder];
        
        if  (_placeholderString)
        {
            [_inputTextView setText:_placeholderString];
        }
        
        [self.view addSubview:_editNormalView];
    }
    else
    {
        [self.navigationItem setTitle:NSLocalizedString(@"privacy", @"privacy")];
        _commentMeSegmentControl = [_commentMeSegmentControl initWithFrame:_commentMeSegmentControl.frame leftText:NSLocalizedString(@"allow", @"allow") rightText:NSLocalizedString(@"not_allow", @"not_allow") selectedIndex:0];
        _atMeSegmentControl = [_atMeSegmentControl initWithFrame:_atMeSegmentControl.frame leftText:NSLocalizedString(@"allow", @"allow") rightText:NSLocalizedString(@"not_allow", @"not_allow") selectedIndex:0];
        _privateLetterMeSegmentControl = [_privateLetterMeSegmentControl initWithFrame:_privateLetterMeSegmentControl.frame leftText:NSLocalizedString(@"allow", @"allow") rightText:NSLocalizedString(@"not_allow", @"not_allow") selectedIndex:0];
        
        NSString * radioButtonGroupId = @"RadioButtonInEdittingView";

        RadioButton * radioButton1 = [[RadioButton alloc] initWithGroupId:radioButtonGroupId text:NSLocalizedString(@"only_to_my_followed", @"") index:0];
        RadioButton * radioButton2 = [[RadioButton alloc] initWithGroupId:radioButtonGroupId text:NSLocalizedString(@"not_to_anyone", @"") index:1];
        
        radioButton1.frame = CGRectMake(15, 210, 240, 30);
        radioButton2.frame = CGRectMake(15, 250, 240, 30);
        
        [_editPrivaceView addSubview:_commentMeSegmentControl];
        [_editPrivaceView addSubview:_atMeSegmentControl];
        [_editPrivaceView addSubview:_privateLetterMeSegmentControl];
        [_editPrivaceView addSubview:radioButton1];
        [_editPrivaceView addSubview:radioButton2];
        
        [self.view addSubview:_editPrivaceView];
        
        [radioButton1 release];
        [radioButton2 release];
    }
}

-(void)dealloc
{
    [_inputTextView release];
    [_editNormalView release];
    [_editPrivaceView release];
    [_commentMeSegmentControl release];
    [_atMeSegmentControl release];
    [_privateLetterMeSegmentControl release];
    Block_release(_callBack);
    [_placeholderString release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    self.inputTextView = nil;
    self.editNormalView = nil;
    self.editPrivaceView = nil;
    self.commentMeSegmentControl = nil;
    self.atMeSegmentControl = nil;
    self.privateLetterMeSegmentControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
