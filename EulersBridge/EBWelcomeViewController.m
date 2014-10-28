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

@interface EBWelcomeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;

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
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [service getNewsWithInstitutionId:@"26"];
    
    self.contentPushedUp = NO;
    
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


-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self pushContentDown];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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
