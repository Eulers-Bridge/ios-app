//
//  EBNewsDetailViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBNewsDetailViewController.h"
#import "EBHelper.h"
#import <EventKit/EventKit.h>
#import <Social/Social.h>

@interface EBNewsDetailViewController ()

@end

@implementation EBNewsDetailViewController

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
    
    // test dates
    
}




- (IBAction)addToCalendar:(UIButton *)sender
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not allowed");
            return;
        }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Event Title";
        event.location = @"Event Location";
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd HHmm"];
        NSDate *date = [formatter dateFromString:@"20140426 2100"];
        
        
        event.startDate = date;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        
        [[[UIAlertView alloc] initWithTitle:@"Event Added" message:@"The Event is successfully added to your calendar." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }];
}


- (IBAction)shareOnFacebook:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *fbPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPost setInitialText:@"This is a test post from our app."];
        [fbPost addImage:[UIImage imageNamed:@"placeholder"]];
        [self presentViewController:fbPost animated:YES completion:nil];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login Facebook in settings -> Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}


- (IBAction)shareOnTwitter:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:@"This is a test post from our app."];
        [tweet addImage:[UIImage imageNamed:@"placeholder"]];
        
        [self presentViewController:tweet animated:YES completion:nil];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login Twitter in settings -> Twitter" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
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
