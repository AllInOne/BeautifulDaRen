//
//  MineEditingViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 5/10/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MineEditingViewController.h"
#import "MyInfoTopViewCell.h"
#import "ViewHelper.h"
#import "ButtonViewCell.h"
#import "EdittingViewController.h"
#import "SelectCityViewController.h"
#import "SegmentControl.h"
#import "iToast.h"
#import "ViewConstants.h"
#import "ModifyPasswordViewController.h"
#import "UIImage+Scale.h"
#import "BSDKDefines.h"
#import "BSDKManager.h"
#import "UIImageView+WebCache.h"

@interface MineEditingViewController()

@property (retain, nonatomic) IBOutlet UIButton * updateAvatarButton;
@property (retain, nonatomic) NSMutableDictionary * tableViewDict;
@property (retain, nonatomic) UIImage * avatarImage;

- (void)startCameraAction;
@end
 
@implementation MineEditingViewController
@synthesize updateAvatarButton = _updateAvatarButton;
@synthesize tableViewDict = _tableViewDict;
@synthesize avatarImage = _avatarImage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    [[BSDKManager sharedManager] modifyUser:[ViewHelper getMyUserId] 
                                       name:[_tableViewDict objectForKey:KEY_ACCOUNT_USER_NAME]
                                     gender:[_tableViewDict objectForKey:KEY_ACCOUNT_GENDER]
                                      email:[_tableViewDict objectForKey:KEY_ACCOUNT_EMAIL]
                                    city:[_tableViewDict objectForKey:KEY_ACCOUNT_CITY]
                                        tel:[_tableViewDict objectForKey:KEY_ACCOUNT_PHONE] 
                                    address:[_tableViewDict objectForKey:KEY_ACCOUNT_ADDRESS]
                                     avatar:self.avatarImage 
                            andDoneCallback:^(AIO_STATUS status, NSDictionary *data) {
                                [[iToast makeText:K_BSDK_GET_RESPONSE_MESSAGE(data)] show];
                            }];
    [self.avatarImage release];
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [super dealloc];
    [_updateAvatarButton release];
    [_tableViewDict release];
    [_avatarImage release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"edit_profile", @"edit_profile")];
    [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
    [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSaveButtonClicked) title:NSLocalizedString(@"save", @"save")]];
    _tableViewDict = [[NSMutableDictionary alloc] init];
    
    [_tableViewDict removeAllObjects];
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_LOCAL_ACCOUNT_INFO];
    _tableViewDict = [dict mutableCopy];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.updateAvatarButton = nil;
    self.tableViewDict = nil;
    self.avatarImage = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        case 1:
        {
            number = 1;
            break;
        }
        case 2:
        {
            number = 7;
            break;
        }
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * infoTopViewIdentifier = @"MyInfoTopViewCell";
    static NSString * buttonViewCellIdentifier = @"ButtonViewCell";
    
    UITableViewCell * cell;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:infoTopViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:infoTopViewIdentifier owner:self options:nil] objectAtIndex:1];
            
            if (self.avatarImage) {
                ((MyInfoTopViewCell*)cell).avatarImageView.image = self.avatarImage;
            }
            else
            {
                NSString * avatarUrl = [self.tableViewDict objectForKey:K_BSDK_PICTURE_65];
                if (avatarUrl && [avatarUrl length]) {
                    [((MyInfoTopViewCell*)cell).avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl]];
                }
                else
                {
                    ((MyInfoTopViewCell*)cell).avatarImageView.image = [UIImage imageNamed:@"avatar_big"];
                }            
            }

            _updateAvatarButton =  ((MyInfoTopViewCell*)cell).updateAvatarButton;
            ((MyInfoTopViewCell*)cell).delegate = self;
        }
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:5];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        buttonViewCell.leftLabel.text = NSLocalizedString(@"gender", @"gender");

        NSInteger index = [[_tableViewDict valueForKey:KEY_ACCOUNT_GENDER] isEqualToString:K_BSDK_GENDER_MALE] ? 1 : 0;
        SegmentControl * seg = [[SegmentControl alloc]
                                initWithFrame:CGRectMake(65, 8, 112, 29)
                                leftText:NSLocalizedString(@"female", @"gender")
                                rightText:NSLocalizedString(@"male", @"gender")
                                selectedIndex:index];
        
        [buttonViewCell addSubview:seg];
        seg.delegate = self;
        [seg release];
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:buttonViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:buttonViewCellIdentifier owner:self options:nil] objectAtIndex:3];
        }
        ButtonViewCell * buttonViewCell = (ButtonViewCell*)cell;
        switch ([indexPath row]) {
            case 0:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"nickname", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_USER_NAME];
                break;
            }
            case 1:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"modify_password", @"");
                buttonViewCell.leftLabel.frame = CGRectMake(buttonViewCell.leftLabel.frame.origin.x,
                                                            buttonViewCell.leftLabel.frame.origin.y,
                                                            [ViewHelper getWidthOfText:buttonViewCell.leftLabel.text ByFontSize:buttonViewCell.leftLabel.font.pointSize],
                                                            buttonViewCell.leftLabel.frame.size.height);
                buttonViewCell.buttonText.text =@"";
                buttonViewCell.buttonText.frame = CGRectZero;
                break;
            }
            case 2:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"city", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_CITY];
                break;
            }
            case 3:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"address", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_ADDRESS];
                break;
            }
            case 4:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"phone", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_PHONE];
                break;
            }
            case 5:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"senior", @"");
                buttonViewCell.buttonText.text = @"高级内容";
                break;
            } 
            case 6:
            {
                buttonViewCell.leftLabel.text = NSLocalizedString(@"brief", @"");
                buttonViewCell.buttonText.text = [_tableViewDict valueForKey:KEY_ACCOUNT_INTRO];
                break;
            } 
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    NSInteger section = [indexPath section];
    switch (section) {
        case 0:
        {
            height = 72.0f;
            break;
        }
        case 1:
        {
            height = 40.0f;
            break;
        }
        case 2:
        {
            height = 40.0f;
            break;
        }    }
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if(section == 2)
    {
        NSInteger type = 0;
        NSInteger row = [indexPath row];
        
        if(row == 1)
        {
            ModifyPasswordViewController *modifiyPasswordViewController = 
            [[ModifyPasswordViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: modifiyPasswordViewController];
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [modifiyPasswordViewController release];
        }
        else if(row == 2)
        {
            SelectCityViewController *citySelectionController = 
            [[SelectCityViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: citySelectionController];
            citySelectionController.delegate = self;
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [citySelectionController release];
        }
        else {
            EditDoneBlock block = nil;
            
            if(row == 5)
            {
                type = EdittingViewController_type1;
                
            }
            else
            {
                type = EdittingViewController_type0;
                switch (row) {
                    case 0:
                    {
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_USER_NAME];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case 3:
                    {
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_ADDRESS];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case 4:
                    {
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_PHONE];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                    case 6:
                    {
                        block = ^(NSString * text)
                        {
                            [_tableViewDict setValue:text
                                              forKey:KEY_ACCOUNT_INTRO];
                            [self.tableView reloadData];
                        };
                        break;
                    }
                }
            }
            EdittingViewController * edittingViewController = [[EdittingViewController alloc]
                                                               initWithNibName:@"EdittingViewController" 
                                                               bundle:nil
                                                               type:type
                                                               block:block];
            [self.navigationController pushViewController:edittingViewController animated:YES];
            [edittingViewController release];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void) genderSelected:(UISegmentedControl*)segmentedControl
{
    [ViewHelper showSimpleMessage:@"你修改了性别" withTitle:nil withButtonText:@"好"];
}

#pragma mark ButtonPressDelegate
- (void) didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    if(button == _updateAvatarButton)
    {
        [self startCameraAction];
    }
}

#pragma mark SegmentDelegate
-(void)segmentChooseAtIndex:(NSInteger)index
{
    NSString * gender = (index == 0) ? K_BSDK_GENDER_FEMALE : K_BSDK_GENDER_MALE;
    [_tableViewDict setValue:gender
                      forKey:KEY_ACCOUNT_GENDER];
}

#pragma mark SelectCityProtocol
- (void)onCitySelected:(NSString*)city
{
    [_tableViewDict setValue:city
                      forKey:KEY_ACCOUNT_CITY];
    [self.tableView reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet destructiveButtonIndex])
    {
        switch (actionSheet.tag)
        {
            case ACTIONSHEET_IMAGE_PICKER:
            {
                NSString *pressed = [actionSheet buttonTitleAtIndex:buttonIndex];
                
                if ([pressed isEqualToString:IMAGE_PICKER_CAMERA])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];
                    
                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
                    
                    [self presentModalViewController:imagePicker animated:YES];
                    
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_LIBRARY])
                {
                    UIImagePickerController * imagePicker = [APPDELEGATE getImagePicker];
                    
                    [imagePicker setDelegate: self];
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    
                    [self presentModalViewController:imagePicker animated:YES];
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_DELETE])
                {
                    // TODO:
                }
            }
            default:
                break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:NO];

    self.avatarImage = [image scaleToSize:CGSizeMake(320.0, image.size.height * 320.0/image.size.width)];
    [(UITableView*)self.view reloadData];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)startCameraAction
{
    UIActionSheet * imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
    
    imagePickerActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    imagePickerActionSheet.tag = ACTIONSHEET_IMAGE_PICKER;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
        {
            [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_CAMERA];        
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_LIBRARY];
    }
    
    if ([imagePickerActionSheet numberOfButtons] > 0)
    {
        [imagePickerActionSheet setDestructiveButtonIndex:[imagePickerActionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"cancel")]];
        [imagePickerActionSheet showInView:self.view];
    }
    
    [imagePickerActionSheet release];
}

@end
