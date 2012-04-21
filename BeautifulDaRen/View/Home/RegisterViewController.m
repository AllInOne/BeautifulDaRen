//
//  RegisterViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/20/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController()

@property (nonatomic, retain) IBOutlet UIPickerView * cityPickerView;
@property (nonatomic, retain) NSMutableArray * cityPickerDataSrouce;
@property (nonatomic, retain) IBOutlet UISegmentedControl * genderChooser;

@end

@implementation RegisterViewController

@synthesize cityPickerView = _cityPickerView;
@synthesize cityPickerDataSrouce = _cityPickerDataSrouce;
@synthesize scrollView = _scrollView;
@synthesize genderChooser = _genderChooser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cityPickerDataSrouce = [NSMutableArray arrayWithObjects:@"成都", @"重庆", @"北京", @"上海", nil];
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
    [self.scrollView setContentSize:CGSizeMake(320, 720)];
    [self.genderChooser addTarget:self action:@selector(genderChooserAction:) forControlEvents:UIControlEventValueChanged];
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

#pragma mark PickerDataSrouce

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.cityPickerDataSrouce count];
}

- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,240.0f,240.0f)];
    showLabel.text = [self.cityPickerDataSrouce objectAtIndex:row];
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.textAlignment = UITextAlignmentCenter;
    return [showLabel autorelease];
}

#pragma mark UIPickerViewDelegate

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //TODO handle select city information.
}

-(void)genderChooserAction:(UISegmentedControl *)Seg
{
    // TODO handle change gender action.
}

@end
