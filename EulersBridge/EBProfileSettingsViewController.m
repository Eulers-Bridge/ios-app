//
//  EBProfileSettingsViewController.m
//  Isegoria
//
//  Created by Alan Gao on 30/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBProfileSettingsViewController.h"
#import "MyConstants.h"
#import "GKImagePicker.h"

@interface EBProfileSettingsViewController () <GKImagePickerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) GKImagePicker *gkImagePicker;
@property EBProfilePhotoType changeProfilePhotoType;

@end

@implementation EBProfileSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
    self.profileImageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button actions
- (IBAction)changeProfilePhoto:(id)sender
{
    self.changeProfilePhotoType = EBProfilePhotoTypeProfile;
    [self showPicker:sender];
}

- (IBAction)changeCoverPhoto:(id)sender {
    self.changeProfilePhotoType = EBProfilePhotoTypeBackground;
    [self showPicker:sender];
}

- (IBAction)logoutAction:(UIBarButtonItem *)sender
{
    [[[UIActionSheet alloc] initWithTitle:@"Are you sure to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil, nil] showFromTabBar:self.tabBarController.tabBar];
}

#pragma image picker

- (void)showPicker:(UIButton *)sender {
    if (!self.gkImagePicker) {
        self.gkImagePicker = [[GKImagePicker alloc] init];
        self.gkImagePicker.delegate = self;
        self.gkImagePicker.cropSize = CGSizeMake(320.0, 320.0);
    }
    [self.gkImagePicker showActionSheetOnViewController:self onPopoverFromView:sender];
    
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if (self.changeProfilePhotoType == EBProfilePhotoTypeProfile) {
        self.profileImageView.image = image;
    } else if (self.changeProfilePhotoType == EBProfilePhotoTypeBackground) {
        self.imageView.image = image;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSUInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    // Upload the photo
}

#pragma mark action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
