//
//  WeiboComposerViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeiboComposerViewController.h"
#import "FriendsSelectionViewController.h"
#import "ViewHelper.h"
#import "TakePhotoViewController.h"
#import "SinaSDKManager.h"

#define WEIBO_CONTENT_TEXTVIEW_Y_OFFSET (90.0)
#define TOOL_BAR_HEIGHT                 (30.0)
#define WEIBO_CONTENT_TEXTVIEW_MARGIN   (2.0)
#define WEIBO_CONTENT_SCROLL_BOUNCE_SIZE   (30.0)

#define ACTIONSHEET_IMAGE_PICKER 1

#define IMAGE_PICKER_CAMERA       NSLocalizedString(@"照相", @"Label for Action Sheet to take a photo using rear camera")
#define IMAGE_PICKER_LIBRARY      NSLocalizedString(@"相册", @"Label for Action Sheet to take a photo from library")
#define IMAGE_PICKER_DELETE       NSLocalizedString(@"删除已选择相片", @"Label for Action Sheet to delete current photo")


@interface WeiboComposerViewController ()
@property (nonatomic, assign) BOOL isKeypadShow;
@property (nonatomic, assign) TakePhotoViewController * takePhotoViewController;
- (void)setContentFrame:(CGRect)frame;
@end

@implementation WeiboComposerViewController

@synthesize cameraButton = _cameraButton;
@synthesize footerView = _footerView;
@synthesize weiboContentTextView = _weiboContentTextView;
@synthesize maketTextView = _maketTextView;
@synthesize brandTextView = _brandTextView;
@synthesize weiboContentBgTextFiled = _weiboContentBgTextFiled;
@synthesize contentScrollView = _contentScrollView;
@synthesize attachedImageView = _attachedImageView;
@synthesize attachedImageBgButton = _attachedImageBgButton;
@synthesize selectedImage = _selectedImage;
@synthesize isKeypadShow = _isKeypadShow;
@synthesize takePhotoViewController = _takePhotoViewController;
@synthesize sinaButton = _sinaButton;
@synthesize sinaShareImageView = _sinaShareImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _cameraButton.enabled = YES;
        _attachedImageBgButton.enabled = NO;

        [_weiboContentTextView setDelegate:self];

        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBackBarItemOfTarget:self action:@selector(onBackButtonClicked) title:@"返回"]];

        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onSendButtonClicked) title:@"发送"]];
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

    [_brandTextView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self setContentFrame:CGRectMake(_weiboContentBgTextFiled.frame.origin.x, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET, _weiboContentBgTextFiled.frame.size.width, _weiboContentTextView.frame.size.height)];
    
    [_contentScrollView setContentSize:CGSizeMake(_weiboContentTextView.frame.size.width, WEIBO_CONTENT_TEXTVIEW_Y_OFFSET + _weiboContentTextView.frame.size.height + WEIBO_CONTENT_SCROLL_BOUNCE_SIZE)];
    
    if (self.selectedImage != nil)
    {
        [self.attachedImageBgButton setImage:self.selectedImage forState:UIControlStateNormal];
    }

    UIImageView * toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_background"]];
    toolbarBg.contentMode = UIViewContentModeScaleToFill;
    [self.footerView  insertSubview:toolbarBg atIndex:0];
    
    [toolbarBg release];
    
    if ([[SinaSDKManager sharedManager] isLogin])
    {
        [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
    }
    else
    {
        [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_gray"] forState:UIControlStateNormal];
        [self.sinaShareImageView setHidden:YES];
    }
    
    _attachedImageView.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setCameraButton:nil];
    [self setFooterView:nil];
    [self setBrandTextView:nil];
    [self setWeiboContentTextView:nil];
    [self setMaketTextView:nil];
    [self setSelectedImage: nil];
    [self setTakePhotoViewController:nil];
    [self setSinaButton:nil];
    [self setSinaShareImageView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_cameraButton release];
    [_footerView release];
    [_weiboContentTextView release];
    [_maketTextView release];
    [_brandTextView release];
    [_selectedImage release];
    [_takePhotoViewController release];
    [_sinaButton release];
    [_sinaShareImageView release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)note 
{
    if (!self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        [UIView animateWithDuration:animDuration animations:^
         {
             [self setContentFrame: CGRectMake(self.weiboContentTextView.frame.origin.x,
                                               WEIBO_CONTENT_TEXTVIEW_Y_OFFSET,
                                               self.weiboContentTextView.frame.size.width,
                                               self.weiboContentTextView.frame.size.height - kbSize.height)];
             
             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y - kbSize.height);
         }];
        
        self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height - kbSize.height);
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height - kbSize.height);
        self.isKeypadShow = YES;
    }

}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isKeypadShow)
    {
        NSDictionary *info = [note userInfo];
        
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        double animDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animDuration animations:^
         {
             [self setContentFrame:CGRectMake(self.weiboContentTextView.frame.origin.x,
                                              self.weiboContentTextView.frame.origin.y,
                                              self.weiboContentTextView.frame.size.width,
                                              self.weiboContentTextView.frame.size.height + kbSize.height)];
             
             self.footerView.center = CGPointMake(self.footerView.center.x,
                                                  self.footerView.center.y + kbSize.height);
         }];
        
        self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + kbSize.height);
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, self.contentScrollView.contentSize.height + kbSize.height);
        self.isKeypadShow = NO;    
    }
}

- (void)setContentFrame:(CGRect)frame
{
    self.weiboContentTextView.frame = frame;

    self.weiboContentBgTextFiled.frame = CGRectMake(frame.origin.x - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.origin.y - WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.width + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN, frame.size.height + 2 * WEIBO_CONTENT_TEXTVIEW_MARGIN);
}

- (void)onBackButtonClicked {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSendButtonClicked {
    // TODO:
}

- (IBAction)onPickedImagePressed:(id)sender
{
    [self onImagePickerPressed:sender];
}

- (IBAction)onImagePickerPressed:(id)sender
{
    UIActionSheet * imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
    
    imagePickerActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    imagePickerActionSheet.tag = ACTIONSHEET_IMAGE_PICKER;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_CAMERA];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_LIBRARY];
    
//    if (self.messageImage.image)
//        [imagePickerActionSheet addButtonWithTitle:IMAGE_PICKER_DELETE];
    
    if ([imagePickerActionSheet numberOfButtons] > 0)
    {
        [imagePickerActionSheet setDestructiveButtonIndex:[imagePickerActionSheet addButtonWithTitle:@"取消"]];
        [imagePickerActionSheet showInView:self.view];
    }
    
    [imagePickerActionSheet release];
}

- (IBAction)onAtFriendPressed:(id)sender
{
    FriendsSelectionViewController *friendSelectionController = 
    [[[FriendsSelectionViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    friendSelectionController.delegate = self;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: friendSelectionController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
}

- (IBAction)onLocationPressed:(id)sender
{
    //TODO:
}
- (IBAction)onTraderPressed:(id)sender
{
    //TODO:
}

- (IBAction)onCategoryPressed:(id)sender
{
    SelectCategoryViewController *categorySelectionController = 
    [[[SelectCategoryViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    categorySelectionController.delegate = self;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: categorySelectionController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [navController release];
}

- (IBAction)onSinaPressed:(id)sender
{
    if (![[SinaSDKManager sharedManager] isLogin])
    {
        [[SinaSDKManager sharedManager] setRootviewController:self.navigationController];
        [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"Sina SDK login done, status:%d", status);
            [self.sinaButton setImage:[UIImage imageNamed:@"myshow_sina_color"] forState:UIControlStateNormal];
            [self.sinaShareImageView setHidden:NO];
        }];   
    }
    else
    {
        [self.sinaShareImageView setHidden:(self.sinaShareImageView.hidden ? NO : YES)];
    }
}

- (void)didFinishContactSelectionWithContacts:(NSString *)friendId
{
    self.weiboContentTextView.text = [self.weiboContentTextView.text stringByAppendingString: [NSString stringWithFormat:@"@%@ ", friendId]];
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
                    if (self.takePhotoViewController == nil) {
                        _takePhotoViewController =
                        [[TakePhotoViewController alloc] initWithNibName:nil bundle:nil]; 
                    }
                    
                    [self.takePhotoViewController setDelegate: self];
                    [self.takePhotoViewController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
                    [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
                }
                else if ([pressed isEqualToString:IMAGE_PICKER_LIBRARY])
                {
                    if (self.takePhotoViewController == nil) {
                        _takePhotoViewController =
                        [[TakePhotoViewController alloc] initWithNibName:nil bundle:nil]; 
                    }
                    
                    [self.takePhotoViewController setDelegate: self];
                    [self.takePhotoViewController setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
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

#pragma mark - UIImagePickerControllerDelegate/UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.attachedImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (self.attachedImageView.image)
    {
        [self.attachedImageBgButton setBackgroundImage:self.attachedImageView.image forState:UIControlStateNormal];
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - select category delegate
- (void)onCategorySelected:(NSString*)category
{
    //TODO:
}

#pragma mark TakePhotoControllerDelegate

- (void)didTakePicture:(UIImage *)picture
{
    [self dismissModalViewControllerAnimated:YES];
    self.attachedImageView.image = picture;
    if (self.attachedImageView.image)
    {
        [self.attachedImageBgButton setBackgroundImage:self.attachedImageView.image forState:UIControlStateNormal];
    }
}

- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didChangeToGalleryMode
{
    if (self.takePhotoViewController != nil) {
        [self setTakePhotoViewController:nil];
    }
    if (self.takePhotoViewController == nil) {
        _takePhotoViewController =
        [[TakePhotoViewController alloc] initWithNibName:nil bundle:nil]; 
    }
    
    [self.takePhotoViewController setDelegate: self];
    [self.takePhotoViewController setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];

    [self dismissViewControllerAnimated:NO completion:^{

        [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
    }];
}
@end
