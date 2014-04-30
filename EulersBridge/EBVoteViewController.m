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

@interface EBVoteViewController () <UIPickerViewDataSource, UIPickerViewDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *scanResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) NSArray *votingDates;
@property (strong, nonatomic) NSArray *votingLocations;
@property (strong, nonatomic) NSArray *pickerViewCurrentArray;

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
    
    self.votingDates = @[@"2014-08-12 14:30", @"2014-08-15 9:30", @"2014-08-20 15:30", @"2014-09-08 16:30", @"2014-09-15 10:30"];
    self.votingLocations = @[@"Union House", @"Baillieu Library", @"ERC Library"];
}





- (IBAction)chooseDate:(UIButton *)sender
{
    self.picker.hidden = NO;
    self.pickerViewCurrentArray = self.votingDates;
    [self.picker reloadAllComponents];
    
    if ([self.dateLabel.text isEqualToString:@""]) {
        self.dateLabel.text = self.pickerViewCurrentArray[[self.picker selectedRowInComponent:0]];
    }
}


- (IBAction)chooseLocation:(UIButton *)sender
{
    self.picker.hidden = NO;
    self.pickerViewCurrentArray = self.votingLocations;
    [self.picker reloadAllComponents];
    
    if ([self.locationLabel.text isEqualToString:@""]) {
        self.locationLabel.text = self.pickerViewCurrentArray[[self.picker selectedRowInComponent:0]];
    }
}




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