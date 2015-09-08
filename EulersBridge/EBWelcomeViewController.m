//
//  EBWelcomeViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBWelcomeViewController.h"
#import "UIImage+ImageEffects.h"
#import "EBNetworkService.h"
#import "EBAppDelegate.h"
#import "EBHelper.h"

@interface EBWelcomeViewController () <UITextViewDelegate, EBUserServiceDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *emailValidIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *passwordValidIndicator;

@property BOOL contentPushedUp;

@end

@implementation EBWelcomeViewController

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
    // Font setup
    self.learnMoreButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.learnMoreButton.titleLabel.font.pointSize];

    
    // Image setup
    UIColor *tintColor = [UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:0.5];
    self.backgroundImageView.image = [self.backgroundImageView.image applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // testing
//    EBNetworkService *service = [[EBNetworkService alloc] init];
//    [service getNewsWithInstitutionId:@"26"];
//    [service getGeneralInfo];
    
    self.contentPushedUp = NO;
    self.activityIndicator.hidesWhenStopped = YES;
    
    // relogin the user if possible
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"];
    if (email && password) {
        self.emailTextField.text = email;
        self.passwordTextField.text = password;
        [self loginAction:self.loginButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)loginAction:(id)sender
{
    [self dismissKeyboard];
    if ([self verifyFields]) {
        [self.activityIndicator startAnimating];
        self.emailTextField.enabled = NO;
        self.passwordTextField.enabled = NO;
        self.loginButton.enabled = NO;
        self.signupButton.enabled = NO;
        
        EBNetworkService *service = [[EBNetworkService alloc] init];
        service.userDelegate = self;
        [service loginWithEmailAddress:self.emailTextField.text password:self.passwordTextField.text];
    }
    
}

- (void)loginFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error errorString:(NSString *)errorString
{
    [self.activityIndicator stopAnimating];
    self.emailTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.loginButton.enabled = YES;
    self.signupButton.enabled = YES;
    
    if (success) {
        EBAppDelegate *delegate = (EBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate instantiateTabBarController];
    } else {
        if ([errorString isEqualToString:LOGIN_ERROR_BAD_CREDENTIALS]) {
            [self highlightFields];
        } else if ([errorString isEqualToString:LOGIN_ERROR_USER_UNVERIFIED]) {
            [self performSegueWithIdentifier:@"LoginEmailUnverified" sender:self];
        }
    }
}

- (void)highlightFields
{
    self.emailTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
    self.emailValidIndicator.image = [UIImage imageNamed:@"Cross"];
    self.passwordTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
    self.passwordValidIndicator.image = [UIImage imageNamed:@"Cross"];
}

- (BOOL)verifyFields
{
    BOOL allGood = YES;
    UIImage *tick = [UIImage imageNamed:@"Tick"];
    UIImage *cross = [UIImage imageNamed:@"Cross"];
    
    if ([EBHelper NSStringIsValidEmail:self.emailTextField.text]) {
        self.emailTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.emailValidIndicator.image = tick;
    } else {
        self.emailTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.emailValidIndicator.image = cross;
        allGood = NO;
    }
    
    if ([self.passwordTextField.text length] >= 6) {
        self.passwordTextField.textColor = ISEGORIA_COLOR_SIGNUP_GREEN;
        self.passwordValidIndicator.image = tick;
    } else {
        self.passwordTextField.textColor = ISEGORIA_COLOR_SIGNUP_RED;
        self.passwordValidIndicator.image = cross;
        allGood = NO;
    }
    return allGood;
}

- (void)restoreFields
{
    self.emailTextField.textColor = [UIColor blackColor];
    self.emailValidIndicator.image = nil;
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordValidIndicator.image = nil;
}

- (IBAction)skipToMainContent:(id)sender
{
    EBAppDelegate *delegate = (EBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate instantiateTabBarController];
}



-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self pushContentDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self restoreFields];
    if (!self.contentPushedUp) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.containerView.frame;
            frame.origin.y -= 78;
            self.containerView.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
        self.contentPushedUp = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
        [self pushContentDown];
        return NO;
    }
    return YES;
}

- (void)pushContentDown
{
    if (self.contentPushedUp) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = self.containerView.frame;
            frame.origin.y += 78;
            self.containerView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
        self.contentPushedUp = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
