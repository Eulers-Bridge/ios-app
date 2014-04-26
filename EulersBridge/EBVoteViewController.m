//
//  EBVoteViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBVoteViewController.h"
#import <EventKit/EventKit.h>

@interface EBVoteViewController ()

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
}





- (IBAction)setReminder:(UIButton *)sender
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not allowed");
            return;
        }
        
        EKReminder *reminder = [EKReminder reminderWithEventStore:store];
        reminder.title = @"Vote for student union election";
        reminder.location = @"Union House";
        
        
        NSDateComponents *start = reminder.startDateComponents;
        start.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"AEST"];
        start.year = 2014;
        start.month = 4;
        start.day = 26;
        start.hour = 21;
        start.minute = 0;
        reminder.startDateComponents = start;
        
        
        
        NSError *err = nil;
        
        
        [store saveReminder:reminder commit:YES error:&err];
        
        [[[UIAlertView alloc] initWithTitle:@"Reminder Set" message:@"The reminder is successfully set." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }];

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
