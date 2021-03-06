//
//  EBContentViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBContentViewController.h"
#import "EBArticleViewController.h"
#import "EBEventDetailTableViewController.h"
#import "EBProfileDescriptionViewController.h"
#import "EBNetworkService.h"
#import "UIImageView+AFNetworking.h"
#import "EBHelper.h"
#import "EBContentDetail.h"
#import "EBTicketViewController.h"
#import "EBProfileContentViewController.h"
#import "EBUserService.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AWSS3.h"

@interface EBContentViewController () <UIScrollViewDelegate, EBUserServiceDelegate, EBContentServiceDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet EBLabelLight *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadProfilePictureButton;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressView;

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) NSMutableArray *signUpNetworkServices;
@property BOOL isPickingPhoto;
@property BOOL isInitialLoad;

@end

@implementation EBContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signUpNetworkServices = [NSMutableArray array];
    
    self.centerImageView.hidden = YES;
    self.nameLabel.hidden = YES;
    self.institutionLabel.hidden = YES;
    
    self.contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
    self.loadingIndicator.hidden = YES;
    self.uploadProfilePictureButton.hidden = YES;
    self.uploadProgressView.hidden = YES;
    [self.uploadProgressView setProgress:0.0 animated:NO];
    self.centerImageView.image = [UIImage imageNamed:@"PhotoPlaceHolder"];
    self.centerImageView.contentMode = UIViewContentModeCenter;
    // Load content view
    self.isInitialLoad = YES;
    [self loadContentView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.contentViewType == EBContentViewTypeProfile) {
        if (self.isInitialLoad) {
            self.isInitialLoad = NO;
        } else {
            [self loadContentView];
        }
    }
}


- (void)loadContentView
{
    // Pass information to content views
    
    if (self.contentViewType == EBContentViewTypeNews) {
        
        self.titleLabel.text = self.data[@"title"];
        NSURL *url = [NSURL URLWithString:self.data[@"imageUrl"]];
        [self getImageFromServerWithURL:url];
        self.navigationItem.title = @"News";

        EBArticleViewController *articleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        [self setupDetailViewController:articleVC];
        [self getUserDetailWithEmail:self.data[@"creatorEmail"]];
        

    } else if (self.contentViewType == EBContentViewTypeEvent) {
        
        self.titleLabel.text = self.data[@"title"];
        NSURL *url = [NSURL URLWithString:self.data[@"imageUrl"]];
        [self getImageFromServerWithURL:url];
        self.navigationItem.title = @"Event";
        EBEventDetailTableViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventViewController"];
        self.contentViewController = eventVC;
        [self addChildViewController:eventVC];
        [eventVC didMoveToParentViewController:self];
        [self.contentScrollView addSubview:eventVC.view];
        [eventVC setupData:self.data];
        eventVC.view.frame = CGRectMake(0, self.imageView.frame.size.height, eventVC.view.frame.size.width, eventVC.view.frame.size.height - self.imageView.frame.size.height);
        
        self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.imageView.frame.size.height + eventVC.view.frame.size.height);
        
    } else if (self.contentViewType == EBContentViewTypeCandidateDescription) {
        
        self.titleLabel.hidden = YES;
        self.centerImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.institutionLabel.hidden = NO;
        [self getInstitutionInfo];
        
        self.navigationItem.title = @"Profile";
        
        self.imageView.image = self.image;
        self.centerImageView.image = self.image;
        self.nameLabel.text = [EBHelper fullNameWithUserObject:self.data];
//        self.institutionLabel.text = 
        
        EBProfileDescriptionViewController *profileDesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileDescriptionView"];
        [self setupDetailViewController:profileDesVC];
        
    } else if (self.contentViewType == EBContentViewTypeTicketProfile) {
        
        self.titleLabel.hidden = YES;
        self.centerImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.institutionLabel.hidden = NO;
        [self getInstitutionInfo];
        
        self.navigationItem.title = @"Ticket Profile";
        if (self.data[@"photos"] != [NSNull null]) {
            if ([self.data[@"photos"] count] != 0) {
                [self getImageFromServerWithURL:[NSURL URLWithString:self.data[@"photos"][0][@"url"]]];
            }
        }
        self.nameLabel.text = self.data[@"name"];
        
        EBTicketViewController *ticketVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TicketView"];
        ticketVC.candidates = self.candidates;
        ticketVC.tickets = self.tickets;
        ticketVC.positions = self.positions;
        [self setupDetailViewController:ticketVC];

    } else if (self.contentViewType == EBContentViewTypeProfile) {

        if (!self.isPickingPhoto) {
            self.titleLabel.hidden = YES;
            self.centerImageView.hidden = NO;
            self.nameLabel.hidden = NO;
            self.institutionLabel.hidden = NO;
            self.uploadProfilePictureButton.hidden = NO;
            self.centerImageView.hidden = NO;
            
            [self getInstitutionInfo];
            
            self.navigationItem.title = @"Profile";
            
            if (self.isSelfProfile) {
                [self getUserDetailWithEmail:[EBUserService retriveUserEmail]];
            } else {
                [self getUserDetailWithEmail:self.data[@"email"]];
            }
            
            EBProfileContentViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileContentView"];
            profileVC.isSelfProfile = self.isSelfProfile;
            [self setupDetailViewController:profileVC];
        }
    }
    // Receive content size information
    // Set scroll view content size
}

- (void)setupDetailViewController:(UIViewController <EBContentDetail> *)detailVC
{
    if (self.contentViewController == nil) {
        self.contentViewController = detailVC;
        [self addChildViewController:detailVC];
        [detailVC didMoveToParentViewController:self];
        [self.contentScrollView addSubview:detailVC.view];
        [detailVC setupData:self.data];
        detailVC.view.frame = CGRectMake(0, self.imageView.frame.size.height, detailVC.view.frame.size.width, detailVC.view.frame.size.height);
        
        self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.imageView.frame.size.height + detailVC.view.frame.size.height);
    }
    
}

- (void)getImageFromServerWithURL:(NSURL *)url
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.image = image;
        self.imageView.image = image;
        self.centerImageView.image = image;
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)getInstitutionInfo
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.signUpNetworkServices addObject:service];
    service.contentDelegate = self;
    [service getInstitutionInfoWithInstitutionId:[[NSUserDefaults standardUserDefaults] valueForKey:@"institutionId"]];
}

-(void)getInstitutionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.institutionLabel.text = info[@"name"];
    } else {
        
    }
}

- (void)getUserDetailWithEmail:(NSString *)email
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    [self.signUpNetworkServices addObject:service];
    service.userDelegate = self;
    [service getUserWithUserEmail:email];
}

- (void)getUserWithUserEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        
        if (self.contentViewType == EBContentViewTypeNews) {
            EBArticleViewController *articleVC = (EBArticleViewController *)self.contentViewController;
            [articleVC setupAuthorData:info];
        } else if (self.contentViewType == EBContentViewTypeProfile) {
            [self setupProfileViewWithInfo:info];
        }
        
    } else {
        
    }
}

- (void)setupProfileViewWithInfo:(NSDictionary *)info
{
    EBProfileContentViewController *profileVC = (EBProfileContentViewController *)self.contentViewController;
    [profileVC setupSelfProfileData:info];
    NSString *urlString = info[@"profilePhoto"];
    if ([urlString class] != [NSNull class]) {
        [self getImageFromServerWithURL: [NSURL URLWithString:urlString]];
    }
    
    self.nameLabel.text = [EBHelper fullNameWithUserObject:info];

}

#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.contentScrollView) {
        CGRect frame = self.imageView.frame;
        if (scrollView.contentOffset.y > -64) {
            frame.origin.y = (scrollView.contentOffset.y + 64) * 0.2;
        } else {
            frame.origin.y = (scrollView.contentOffset.y + 64);
            frame.size.height = -(scrollView.contentOffset.y + 64) + 229;
            CGFloat newBlurRadius = (DEFAULT_BLUR_RADIUS + (scrollView.contentOffset.y + 64) * DEFAULT_BLUR_RADIUS / 206);
            if (newBlurRadius < 0.1) {
                newBlurRadius = 0.1;
            }
//            NSLog(@"%f",newBlurRadius);
            [self.imageView setImage:[self.image copy] withBlurRadius:newBlurRadius];
//            NSLog(@"%f",scrollView.contentOffset.y);
        }
        self.imageView.frame = frame;
    }
    
}

- (IBAction)uploadProfilePictureAction:(UIButton *)sender
{
    [self showPicker:sender];
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
    self.isPickingPhoto = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    //    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.image = image;
    self.imageView.image = image;
    self.centerImageView.image = image;
    self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
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
            self.isPickingPhoto = NO;
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

-(void)dealloc
{
    for (EBNetworkService *service in self.signUpNetworkServices) {
        service.userDelegate = nil;
        service.contentDelegate = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
