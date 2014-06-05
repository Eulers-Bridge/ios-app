//
//  EBSignupLoginViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSignupLoginViewController.h"
#import "UIImage+ImageEffects.h"
#import "GKImagePicker.h"

@interface EBSignupLoginViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, GKImagePickerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

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
    // Font setup
    self.nameTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.nameTextField.font.pointSize];
    self.emailTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.emailTextField.font.pointSize];
    self.passwordTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.passwordTextField.font.pointSize];
    self.confirmPasswordTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.confirmPasswordTextField.font.pointSize];
    self.countryTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.countryTextField.font.pointSize];
    self.universityTextField.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.universityTextField.font.pointSize];

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.textFieldContainerView.frame;
        frame.origin.y = 70;
        self.textFieldContainerView.frame = frame;
        self.photoImageView.alpha = 0.0;
    } completion:completion];
}

- (void)pushContentDown
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.textFieldContainerView.frame;
        frame.origin.y = 208;
        self.textFieldContainerView.frame = frame;
        self.photoImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
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
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSUInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    // Upload the photo
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
