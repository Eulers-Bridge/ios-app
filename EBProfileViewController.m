//
//  EBProfileViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 27/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBProfileViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EBBlurImageView.h"
#import "EBBadgesCollectionViewController.h"
#import "EBTasksTableViewController.h"
#import "EBTasksDetailViewController.h"
#import "EBProfileSettingsViewController.h"
#import "EBNetworkService.h"
#import "EBHelper.h"
#import "EBButtonHeavySystem.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AWSS3.h"

@interface EBProfileViewController () <ABPeoplePickerNavigationControllerDelegate, UIScrollViewDelegate, EBContentServiceDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EBUserServiceDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uniNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfXPLabel;

@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *XPLevelLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressView;

@property (weak, nonatomic) IBOutlet UIView *darkBackgroundView;


@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar1;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar2;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar3;
@property (weak, nonatomic) IBOutlet EBCircleProgressBar *progressBar4;

@property (weak, nonatomic) IBOutlet EBLabelLight *completedBadgesLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *remainingBadgesLabel;


@property (strong, nonatomic) NSArray *completedBadges;
@property (strong, nonatomic) NSArray *remainingBadges;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *badgesLoadingIndicator;
@property (weak, nonatomic) IBOutlet UIButton *viewBadgesButton;

@property (strong, nonatomic) NSArray *tasks;
@property (weak, nonatomic) IBOutlet EBButtonHeavySystem *showProgressButton;
@property (weak, nonatomic) IBOutlet EBLabelMedium *tasksLoadingLabel;
@property (weak, nonatomic) IBOutlet UIView *tasksContainerView;



@end

@implementation EBProfileViewController

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
    
    self.viewBadgesButton.enabled = NO;
    self.badgesLoadingIndicator.hidden = YES;
    self.progressBar2.progress = 0.0;
    
    self.showProgressButton.enabled = NO;
    self.tasksContainerView.hidden = YES;
    
    // Image setup
    self.profileImageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
    self.imageView.image = [UIImage imageNamed:@"julia-gillard-data.jpg"];
    self.scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN, 665.0);
    
    // Get Badges and tasks
    [self getBadges];
    [self getTasks];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.progressBar1 animate];
    [self.progressBar2 animate];
    [self.progressBar3 animate];
    [self.progressBar4 animate];
}


- (IBAction)inviteFriends:(UIButton *)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)uploadProfilePictureAction:(UIButton *)sender
{
    [self showPicker:sender];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self dismissViewControllerAnimated:YES completion:nil];

    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}


#pragma mark Badges

- (void)getBadges
{
    self.badgesLoadingIndicator.hidden = NO;
    [self.badgesLoadingIndicator startAnimating];
    self.completedBadgesLabel.hidden = YES;
    self.remainingBadgesLabel.hidden = YES;
    
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getCompleteBadgesWithUserId:[EBHelper getUserId]];
    [service getRemainingBadgesWithUserId:[EBHelper getUserId]];
}

- (void)getTasks
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getTasks];
}

- (void)updateProfilePicURL:(NSString *)profilePicURL
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    [service updateProfilePicURL:profilePicURL];
}

-(void)updateProfilePicURLWithSuccess:(BOOL)success failureReason:(NSError *)error
{
    if (success) {
    } else {
        NSLog(@"Error: %@", error);
    }
}

-(void)getCompleteBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.completedBadges = info[@"foundObjects"];
        [self updateBadges];
    } else {
        NSLog(@"Error: %@", error);
    }
}

- (void)getRemainingBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.remainingBadges = info[@"foundObjects"];
        [self updateBadges];
    } else {
        NSLog(@"Error: %@", error);
    }
}

- (void)getTasksFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.tasks = info[@"foundObjects"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TasksReturnedFromServer" object:nil userInfo:info];
        [self updateTasks];
    } else {
        NSLog(@"Error: %@", error);
    }
}

- (void)updateBadges
{
    if (self.completedBadges && self.remainingBadges) {
        [self.badgesLoadingIndicator stopAnimating];
        self.badgesLoadingIndicator.hidden = YES;
        self.completedBadgesLabel.hidden = NO;
        self.remainingBadgesLabel.hidden = NO;
        self.progressBar2.progress = (float)[self.completedBadges count] / ((float)[self.completedBadges count] + (float)[self.remainingBadges count]);
        [self.progressBar2 animate];
        self.completedBadgesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.completedBadges count]];
        self.remainingBadgesLabel.text = [NSString stringWithFormat:@"/%lu", (unsigned long)[self.remainingBadges count]];;
        self.viewBadgesButton.enabled = YES;
    }
}

- (void)updateTasks
{
    if (self.tasks) {
        self.showProgressButton.enabled = YES;
        self.tasksLoadingLabel.hidden = YES;
        self.tasksContainerView.hidden = NO;
    }
}

#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    CGRect frame = self.imageView.frame;
    if (scrollView.contentOffset.y > 0) {
        frame.origin.y = (scrollView.contentOffset.y + 0) * 0.2;
    } else {
        frame.origin.y = (scrollView.contentOffset.y + 0);
        frame.size.height = -(scrollView.contentOffset.y + 0) + 288;
    }
    self.imageView.frame = frame;

}



- (void)showPicker:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: Show Camera
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // TODO: Show Photo Library
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationPopover;
        picker.popoverPresentationController.sourceView = sender;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:takePhotoAction];
    [alert addAction:libAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.profileImageView.image = image;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    NSUInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %lu ", (unsigned long)imageSize);
    // Upload the photo
    NSString *uuidString = [NSUUID UUID].UUIDString;
    NSString *key = [NSString stringWithFormat:@"%@.jpg", uuidString];
    
    // Transfer the data
    self.uploadProgressView.hidden = NO;
    NSData *dataToUpload = imageData;// The data to upload.
    
    AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
    expression.uploadProgress = ^(AWSS3TransferUtilityTask *task, int64_t bytesSent,
                                  int64_t totalBytesSent,
                                  int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
            [self.uploadProgressView setProgress:progress animated:YES];
        });
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.uploadProgressView.hidden = YES;
            [self.uploadProgressView setProgress:0.0 animated:NO];
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                self.uploadProgressView.hidden = YES;
                [self.uploadProgressView setProgress:0.0 animated:NO];
                [self updateProfilePicURL:[S3_URL_PREFIX stringByAppendingString:key]];
            }
        });
    };
    
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [[transferUtility uploadData:dataToUpload
                          bucket:S3_BUCKET_KEY
                             key:key
                     contentType:@"image"
                      expression:expression
                completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
        
        if (task.error) {
            NSLog(@"Error: %@", task.error);
            self.uploadProgressView.hidden = YES;
            [self.uploadProgressView setProgress:0.0 animated:NO];
            [[[UIAlertView alloc] initWithTitle:@"Upload failed" message:task.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
            self.uploadProgressView.hidden = YES;
            [self.uploadProgressView setProgress:0.0 animated:NO];
            [[[UIAlertView alloc] initWithTitle:@"Upload failed" message:task.exception.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
        if (task.result) {
        }
        
        return nil;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:@"BadgesEmbed"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeSmall;
    }
    if ([segue.identifier isEqualToString:@"BadgesDetail"]) {
        EBBadgesCollectionViewController *badgesViewController = (EBBadgesCollectionViewController *)[segue destinationViewController];
        badgesViewController.badgesViewType = EBBadgesViewTypeDetail;
        badgesViewController.completedBadges = self.completedBadges;
        badgesViewController.remainingBadges = self.remainingBadges;
    }
    if ([segue.identifier isEqualToString:@"ProfileSettings"]) {
        EBProfileSettingsViewController *settingsViewController = (EBProfileSettingsViewController *)[segue destinationViewController];
        
    }
    if ([segue.identifier isEqualToString:@"TasksEmbed"]) {
        EBTasksTableViewController *tasksViewController = (EBTasksTableViewController *)[segue destinationViewController];
        tasksViewController.tasksViewType = EBTasksViewTypeSmall;
    }
    if ([segue.identifier isEqualToString:@"TasksDetail"]) {
        EBTasksDetailViewController *tasksViewController = (EBTasksDetailViewController *)[segue destinationViewController];
        tasksViewController.tasks = self.tasks;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
