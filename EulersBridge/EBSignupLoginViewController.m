//
//  EBSignupLoginViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSignupLoginViewController.h"
#import "EBEmailVerificationViewController.h"
#import "EBSignupTermsViewController.h"
#import "UIImage+ImageEffects.h"
#import "GKImagePicker.h"
#import "EBNetworkService.h"
#import "EBUser.h"

@interface EBSignupLoginViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, GKImagePickerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, EBSignupServiceDelegate, EBSignupTermsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *universityTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *universityButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) NSArray *pickerViewCurrentArray;

@property (strong, nonatomic) GKImagePicker *gkImagePicker;

@property (strong, nonatomic) NSString *institutionIdSelected;
@property (strong, nonatomic) EBNetworkService *networkService;
@property (strong, nonatomic) EBUser *signupedUser;
@property BOOL termsAgreed;
@property BOOL contentPushedUp;

@end

@implementation EBSignupLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Image setup
    UIColor *tintColor = [UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:0.5];
    self.backgroundImageView.image = [self.backgroundImageView.image applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    // Sample Data setup
    self.countries = @[@"Australia", @"China", @"USA"];
    self.universities = @[@"University of Melbourne", @"Curtin University", @"RMIT"];
    
    self.pickerView.hidden = YES;
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    
    [self.view addGestureRecognizer:tap];
    self.networkService = [[EBNetworkService alloc] init];
    self.networkService.signupDelegate = self;
    
    self.termsAgreed = NO;
    self.contentPushedUp = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Setup transparent nav bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}



#pragma mark button actions

- (IBAction)uploadImage:(UIButton *)sender
{
    [self showPicker:sender];
}

- (IBAction)doneClicked:(id)sender
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    // animation
//    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"] animated:YES completion:nil];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.navigationController.view.frame = CGRectOffset(self.navigationController.view.frame, 0.0, 300.0);
//    } completion:^(BOOL finished) {
//        
//        
//    }];

}

- (IBAction)chooseCountry:(UIButton *)sender
{
    [self dismissKeyboard];
    [self pushContentUpWithCompletion:^(BOOL finished) {
        self.pickerView.hidden = NO;
    }];

    self.pickerViewCurrentArray = self.countries;
    [self.pickerView reloadAllComponents];
    
    if ([self.countryTextField.text isEqualToString:@""]) {
        self.countryTextField.text = self.pickerViewCurrentArray[[self.pickerView selectedRowInComponent:0]];
    }
    
}

- (IBAction)chooseUniversity:(UIButton *)sender
{
    [self dismissKeyboard];
    [self pushContentUpWithCompletion:^(BOOL finished) {
        self.pickerView.hidden = NO;
    }];
    self.pickerViewCurrentArray = self.universities;
    [self.pickerView reloadAllComponents];
    
    if ([self.universityTextField.text isEqualToString:@""]) {
        self.universityTextField.text = self.pickerViewCurrentArray[[self.pickerView selectedRowInComponent:0]];
    }

}

- (IBAction)signupAction:(UIBarButtonItem *)sender
{
    // Present terms and conditions.
    if (self.termsAgreed) {
        [self verifyFieldsAndSignup];
    } else {
        EBSignupTermsViewController *termsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        termsViewController.modalPresentationCapturesStatusBarAppearance = YES;
        termsViewController.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
        termsViewController.termsDelegate = self;
        [self presentViewController:termsViewController animated:YES completion:nil];
    }

}



#pragma mark pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerViewCurrentArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerViewCurrentArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewCurrentArray == self.countries) {
        self.countryTextField.text = self.countries[row];
    }
    
    if (self.pickerViewCurrentArray == self.universities) {
        self.universityTextField.text = self.universities[row];
    }
}

#pragma mark textField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self pushContentUpWithCompletion:nil];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.confirmPasswordTextField) {
        [textField resignFirstResponder];
        [self chooseCountry:self.countryButton];
        return NO;
    }
    return YES;
}


#pragma mark tap gesture

- (void)tapAnywhere
{
    [self dismissKeyboard];
    [self pushContentDown];
    self.pickerView.hidden = YES;
}

-(void)dismissKeyboard {
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}


#pragma mark animation
- (void)pushContentUpWithCompletion:(void (^)(BOOL finished))completion
{
    if (!self.contentPushedUp) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.textFieldContainerView.frame;
            frame.origin.y -= 138;
            self.textFieldContainerView.frame = frame;
            self.photoImageView.alpha = 0.0;
        } completion:completion];
        self.contentPushedUp = YES;
    }
    
}

- (void)pushContentDown
{
    if (self.contentPushedUp) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.textFieldContainerView.frame;
            frame.origin.y += 138;
            self.textFieldContainerView.frame = frame;
            self.photoImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        self.contentPushedUp = NO;
    }
    
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
    self.photoImageView.image = image;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSUInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    // Upload the photo
}

#pragma mark signup delegate
-(void)signupFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason
{
    // advance to next page or display the error.
    if (success) {
        self.signupedUser = user;
        [self performSegueWithIdentifier:@"SignupAction" sender:self];
    } else {
        // Display error reason.
    }
}

#pragma mark terms delegate
-(void)signupTermsAgreed:(BOOL)agreed
{
    if (agreed) {
        self.termsAgreed = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            [self verifyFieldsAndSignup];
        }];
        
    } else {
        self.termsAgreed = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)verifyFieldsAndSignup
{
    // Verify the fields.
    [self.networkService signupWithEmailAddress:self.emailTextField.text
                                       password:self.passwordTextField.text
                                           name:self.nameTextField.text
                                  institutionId:self.institutionIdSelected];
    // Set the spinning wheel or equivelent.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SignupAction"]) {
        EBEmailVerificationViewController *emailVerificationViewController = (EBEmailVerificationViewController *)[segue destinationViewController];
        emailVerificationViewController.user = self.signupedUser;
    }
}

@end
