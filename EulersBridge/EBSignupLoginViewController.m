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
#import "MyConstants.h"
#import "EBHelper.h"
#import "EBPersonalityDescriptionViewController.h"

@interface EBSignupLoginViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, GKImagePickerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, EBUserServiceDelegate, EBSignupTermsDelegate, EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *universityTextField;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *universityButton;

@property (weak, nonatomic) IBOutlet UIImageView *nameValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *familyNameValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *emailValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *passwordValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *confirmPasswordValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *countryValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *universityValidIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) NSArray *pickerViewCurrentArray;

@property (strong, nonatomic) GKImagePicker *gkImagePicker;

@property (strong, nonatomic) NSString *institutionIdSelected;
@property (strong, nonatomic) EBNetworkService *networkService;
@property (strong, nonatomic) EBUser *signupedUser;

@property NSInteger countrySelected;
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
    if (SAMPLE_DATA) {
        self.countries = @[@"Australia", @"China", @"USA"];
        self.universities = @[@"University of Melbourne", @"Curtin University", @"RMIT"];
    } else {
        self.countries = @[];
        self.universities = @[];

    }
    
    self.countryButton.enabled = NO;
    self.pickerView.hidden = YES;
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    
    [self.view addGestureRecognizer:tap];
    self.networkService = [[EBNetworkService alloc] init];
    self.networkService.userDelegate = self;
    self.networkService.contentDelegate = self;
    
    [self.networkService getGeneralInfo];
    
    self.termsAgreed = NO;
    self.contentPushedUp = NO;
    self.countrySelected = 0;
    self.universityButton.enabled = NO;
    
    self.institutionIdSelected = @"";
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
    self.pickerView.hidden = NO;
    [self pushContentUpWithCompletion:^(BOOL finished) {
        self.pickerView.hidden = NO;
    }];

    self.pickerViewCurrentArray = self.countries;
    [self.pickerView reloadAllComponents];
    
    [self.pickerView selectRow:self.countrySelected inComponent:0 animated:NO];
    
    if ([self.countryTextField.text isEqualToString:@""]) {
        self.countryTextField.text = self.pickerViewCurrentArray[[self.pickerView selectedRowInComponent:0]];
        self.countrySelected = 0;
    }
    self.universityButton.enabled = YES;
    self.universityTextField.text = @"";
}

- (IBAction)chooseUniversity:(UIButton *)sender
{
    [self dismissKeyboard];
    [self pushContentUpWithCompletion:^(BOOL finished) {
        self.pickerView.hidden = NO;
    }];
    self.pickerViewCurrentArray = self.universities[self.countrySelected];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
    if ([self.universityTextField.text isEqualToString:@""]) {
        self.universityTextField.text = self.pickerViewCurrentArray[[self.pickerView selectedRowInComponent:0]];
        self.institutionIdSelected = self.generalInfo[@"countrys"][self.countrySelected][@"institutions"][0][@"institutionId"];
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
        self.countrySelected = row;
    }
    
    if (self.pickerViewCurrentArray == self.universities[self.countrySelected]) {
        self.universityTextField.text = self.universities[self.countrySelected][row];
        self.institutionIdSelected = self.generalInfo[@"countrys"][self.countrySelected][@"institutions"][row][@"institutionId"];
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
        [self.familyNameTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.familyNameTextField) {
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
    [self.familyNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}


#pragma mark animation
- (void)pushContentUpWithCompletion:(void (^)(BOOL finished))completion
{
    [self restoreFields];
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
    [self presentViewController:self.gkImagePicker animated:YES completion:nil];
    
}

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.photoImageView.image = image;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSUInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    // Upload the photo
    
}

#pragma mark content delegate

- (void)getGeneralInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.generalInfo = info;
        NSMutableArray *countries = [NSMutableArray array];
        NSMutableArray *institutions = [NSMutableArray array];
        for (NSDictionary *country in info[@"countrys"]) {
            [countries addObject:country[@"countryName"]];
            NSMutableArray *institutionsInOneCountry = [NSMutableArray array];
            for (NSDictionary *institution in country[@"institutions"]) {
                [institutionsInOneCountry addObject:institution[@"institutionName"]];
            }
            [institutions addObject:[institutionsInOneCountry copy]];
        }
        self.countries = [countries copy];
        self.universities = [institutions copy];
        self.countryButton.enabled = YES;
    } else {
        // Display error reason.
    }
}

#pragma mark signup delegate
-(void)signupFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason
{
    [self.activityIndicator stopAnimating];
    // advance to next page or display the error.
    if (success) {
        self.signupedUser = user;
        [self performSegueWithIdentifier:@"ShowPersonalityDescription" sender:self];
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
    [self tapAnywhere];
    // Verify the fields.
    if ([self verifyFields]) {
    [self.networkService signupWithEmailAddress:self.emailTextField.text
                                       password:self.passwordTextField.text
                                      givenName:self.nameTextField.text
                                       familyName:self.familyNameTextField.text
                                  institutionId:self.institutionIdSelected];
    // Set the spinning wheel or equivelent.
    [self.activityIndicator startAnimating];
    }
}

- (BOOL)verifyFields
{
    BOOL allGood = YES;
    UIImage *tick = [UIImage imageNamed:@"Tick"];
    UIImage *cross = [UIImage imageNamed:@"Cross"];
    
    if ([self.nameTextField.text length] == 0) {
        self.nameTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.nameValidIndicator.image = cross;
        allGood = NO;
    } else {
        self.nameTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.nameValidIndicator.image = tick;
    }
    
    if ([self.familyNameTextField.text length] == 0) {
        self.familyNameTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.familyNameValidIndicator.image = cross;
        allGood = NO;
    } else {
        self.familyNameTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.familyNameValidIndicator.image = tick;
    }

    
    if ([EBHelper NSStringIsValidEmail:self.emailTextField.text]) {
        self.emailTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.emailValidIndicator.image = tick;
    } else {
        self.emailTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.emailValidIndicator.image = cross;
        allGood = NO;
    }
    
    self.confirmPasswordTextField.enabled = NO;
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text] && [self.passwordTextField.text length] >= 6) {
        self.passwordTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.confirmPasswordTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.passwordValidIndicator.image = tick;
        self.confirmPasswordValidIndicator.image = tick;
    } else {
        self.passwordTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.confirmPasswordTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.passwordValidIndicator.image = cross;
        self.confirmPasswordValidIndicator.image = cross;
        allGood = NO;
    }
    
    if ([self.countryTextField.text length] == 0) {
        // show cross
        self.countryValidIndicator.image = cross;
        allGood = NO;
    } else {
        self.countryTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.countryValidIndicator.image = tick;
    }
    
    if ([self.universityTextField.text length] == 0) {
        // show cross
        self.universityValidIndicator.image = cross;
        allGood = NO;
    } else {
        self.universityTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.universityValidIndicator.image = tick;
    }
    return allGood;
}

- (void)restoreFields
{
    self.nameTextField.enabled = YES;
    self.nameTextField.textColor = [UIColor blackColor];
    self.familyNameTextField.enabled = YES;
    self.familyNameTextField.textColor = [UIColor blackColor];
    self.nameValidIndicator.image = nil;
    self.emailTextField.enabled = YES;
    self.emailTextField.textColor = [UIColor blackColor];
    self.emailValidIndicator.image = nil;
    self.passwordTextField.enabled = YES;
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordValidIndicator.image = nil;
    self.confirmPasswordTextField.enabled = YES;
    self.confirmPasswordTextField.textColor = [UIColor blackColor];
    self.confirmPasswordValidIndicator.image = nil;
    self.countryButton.enabled = YES;
    self.countryTextField.backgroundColor = [UIColor whiteColor];
    self.countryTextField.textColor = [UIColor blackColor];
    self.countryValidIndicator.image = nil;
    self.universityButton.enabled = YES;
    self.universityTextField.backgroundColor = [UIColor whiteColor];
    self.universityTextField.textColor = [UIColor blackColor];
    self.universityValidIndicator.image = nil;
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
    if ([segue.identifier isEqualToString:@"ShowPersonalityDescription"]) {
        EBPersonalityDescriptionViewController *personalityDescriptionViewController = (EBPersonalityDescriptionViewController *)[segue destinationViewController];
        personalityDescriptionViewController.user = self.signupedUser;
    }
}

@end
