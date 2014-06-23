//
//  EBVoteViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBVoteViewController.h"
#import <EventKit/EventKit.h>
@import EventKitUI;
#import "CDZQRScanningViewController.h"
#import "MyConstants.h"

@interface EBVoteViewController () <UIPickerViewDataSource, UIPickerViewDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *scanResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) NSArray *votingDates;
@property (strong, nonatomic) NSArray *votingLocations;
@property (strong, nonatomic) NSArray *pickerViewCurrentArray;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *voteLabel0;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel1;

@property (weak, nonatomic) IBOutlet UIView *pledgeView;
@property (weak, nonatomic) IBOutlet UIView *finishView;
@property (weak, nonatomic) IBOutlet UIButton *createReminderButton;

@property (weak, nonatomic) IBOutlet UILabel *finishTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *finishImageView;
@property (weak, nonatomic) IBOutlet UITextView *finishTextView;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;


@end

@implementation EBVoteViewController

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
    self.picker.hidden = YES;
    self.textView.hidden = NO;
    
    self.votingDates = @[@"14:30 12th July 2014", @"14:30 12th July 2014", @"14:30 12th July 2014", @"14:30 12th July 2014", @"14:30 12th July 2014"];
    self.votingLocations = @[@"Union House", @"Baillieu Library", @"ERC Library"];
    
    // Font setup
    self.voteLabel0.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.voteLabel0.font.pointSize];
    self.voteLabel1.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.voteLabel1.font.pointSize];
    self.dateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.dateLabel.font.pointSize];
    self.locationLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.locationLabel.font.pointSize];
    self.textView.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.textView.font.pointSize];
    self.createReminderButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.createReminderButton.titleLabel.font.pointSize];
    
    self.finishTitleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.finishTitleLabel.font.pointSize];
    self.finishTextView.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.finishTextView.font.pointSize];
    self.scanButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.scanButton.titleLabel.font.pointSize];
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    
    [self.view addGestureRecognizer:tap];
    
    // Hide the back button
    self.backButton.tintColor = [UIColor clearColor];
    self.backButton.enabled = NO;
    
}


#pragma mark tap gesture

- (void)tapAnywhere
{
    self.picker.hidden = YES;
    self.textView.hidden = NO;
}

#pragma mark button action

- (IBAction)chooseDate:(UIButton *)sender
{
    self.picker.hidden = NO;
    self.textView.hidden = YES;
    self.pickerViewCurrentArray = self.votingDates;
    [self.picker reloadAllComponents];
    
    if ([self.dateLabel.text isEqualToString:@""]) {
        self.dateLabel.text = self.pickerViewCurrentArray[[self.picker selectedRowInComponent:0]];
    }
}


- (IBAction)chooseLocation:(UIButton *)sender
{
    self.picker.hidden = NO;
    self.textView.hidden = YES;
    self.pickerViewCurrentArray = self.votingLocations;
    [self.picker reloadAllComponents];
    
    if ([self.locationLabel.text isEqualToString:@""]) {
        self.locationLabel.text = self.pickerViewCurrentArray[[self.picker selectedRowInComponent:0]];
    }
}

- (IBAction)back:(UIBarButtonItem *)sender
{
    self.backButton.tintColor = [UIColor clearColor];
    self.backButton.enabled = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect pledgeFrame = self.pledgeView.frame;
        pledgeFrame.origin.x = 0;
        self.pledgeView.frame = pledgeFrame;
        
        CGRect finishFrame = self.finishView.frame;
        finishFrame.origin.x = 320;
        self.finishView.frame = finishFrame;
    } completion:^(BOOL finished) {
        
    }];
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
    if (self.pickerViewCurrentArray == self.votingDates) {
        self.dateLabel.text = self.votingDates[row];
    }
    
    if (self.pickerViewCurrentArray == self.votingLocations) {
        self.locationLabel.text = self.votingLocations[row];
    }
}

// Not available in ios 7
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    UIFont *font = [UIFont fontWithName:@"MuseoSansRounded-300" size:15];
//    return [[NSAttributedString alloc] initWithString:self.pickerViewCurrentArray[row] attributes:@{NSFontAttributeName: font}];
//}



- (IBAction)setReminder:(UIButton *)sender
{
    
    if ([self.dateLabel.text isEqualToString:@""] || [self.locationLabel.text isEqualToString:@""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Please choose date and location" message:@"Please choose date and location before you set reminder." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not allowed");
            return;
        }
        
        
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Voting for student union election";
        event.location = self.locationLabel.text;
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [formatter dateFromString:self.dateLabel.text];
        
        
        event.startDate = date;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        event.allDay = NO;
        
        event.alarms = @[[EKAlarm alarmWithAbsoluteDate:date]];
        
        
        
        EKEventEditViewController *evc = [[EKEventEditViewController alloc] init];
        evc.editViewDelegate = self;
        evc.eventStore = store;
        evc.event = event;
        [self presentViewController:evc animated:YES completion:nil];
        
    }];
    


}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (action == EKEventEditViewActionSaved) {
        self.backButton.tintColor = [UIColor whiteColor];
        self.backButton.enabled = YES;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect pledgeFrame = self.pledgeView.frame;
            pledgeFrame.origin.x = -320;
            self.pledgeView.frame = pledgeFrame;
            
            CGRect finishFrame = self.finishView.frame;
            finishFrame.origin.x = 0;
            self.finishView.frame = finishFrame;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}



- (IBAction)scanQR:(UIButton *)sender
{
    // create the scanning view controller and a navigation controller in which to present it:
    CDZQRScanningViewController *scanningVC = [CDZQRScanningViewController new];
    UINavigationController *scanningNavVC = [[UINavigationController alloc] initWithRootViewController:scanningVC];
    
    // configure the scanning view controller:
    scanningVC.resultBlock = ^(NSString *result) {
        self.scanResultLabel.text = result;
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.cancelBlock = ^() {
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    scanningVC.errorBlock = ^(NSError *error) {
        // todo: show a UIAlertView orNSLog the error
        [scanningNavVC dismissViewControllerAnimated:YES completion:nil];
    };
    
    // present the view controller full-screen on iPhone; in a form sheet on iPad:
    scanningNavVC.modalPresentationStyle = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIModalPresentationFullScreen : UIModalPresentationFormSheet;
    [self presentViewController:scanningNavVC animated:YES completion:nil];}







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
