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
#import "EBHelper.h"

@interface EBVoteViewController () <UIPickerViewDataSource, UIPickerViewDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;

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

@property (strong, nonatomic) NSString *dateSelected;


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
    
    self.votingDates = @[@"2014-07-12 14:30", @"2014-08-12 11:30", @"2014-09-14 12:30", @"2014-10-12 12:00", @"2014-07-12 14:30"];
    self.votingLocations = @[@"Union House", @"Baillieu Library", @"ERC Library"];
    // 14:30 12th July 2014
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    
    [self.view addGestureRecognizer:tap];
    
    // Hide the back button
    self.backButton.hidden = YES;
    self.backButton.enabled = NO;
    
    CGFloat width = [EBHelper getScreenSize].width;
    CGFloat height = [EBHelper getScreenSize].height;
    self.pledgeView.frame = CGRectMake(0, 0, width, height);
    self.finishView.frame = CGRectMake(width, 0, width, height);
    
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
        self.dateLabel.text = [self pickerView:self.picker titleForRow:[self.picker selectedRowInComponent:0] forComponent:0];
        self.dateSelected = self.votingDates[[self.picker selectedRowInComponent:0]];
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

- (IBAction)backToReminder:(id)sender {
    self.backButton.hidden = YES;
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
    if (self.pickerViewCurrentArray == self.votingDates) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [formatter dateFromString:self.pickerViewCurrentArray[row]];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"hh:mm, dd MMMM yyyy"];
        return [formatter2 stringFromDate:date];

    } else {
        return self.pickerViewCurrentArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewCurrentArray == self.votingDates) {
        self.dateLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        self.dateSelected = self.votingDates[row];
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
        NSDate *date = [formatter dateFromString:self.dateSelected];
        
        
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
        self.backButton.hidden = NO;
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
    [self presentViewController:scanningNavVC animated:YES completion:nil];
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
