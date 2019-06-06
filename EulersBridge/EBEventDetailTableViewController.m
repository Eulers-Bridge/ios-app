//
//  EBEventDetailTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 3/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBEventDetailTableViewController.h"
#import "EBCandidateTableViewCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Social/Social.h>
#import "EBHelper.h"

@interface EBEventDetailTableViewController () <EKEventEditViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet EBButtonRoundedHeavy *attendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;

@end

@implementation EBEventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
    self.dateLabel.text = data[@"date"];
    self.textView.text = data[@"article"];
    self.eventLocationLabel.text = data[@"location"];
    CGFloat oldHeight = self.textView.frame.size.height;
    [EBHelper resetTextView:self.textView];
    CGFloat textViewExtraHeight = self.textView.frame.size.height - oldHeight;
    self.mainContentView.frame = CGRectMake(0, 0, self.mainContentView.frame.size.width, self.mainContentView.frame.size.height + textViewExtraHeight);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + textViewExtraHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"CONTACT";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EBCandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CandidateCellSmall" forIndexPath:indexPath];
    if (self.data[@"organizer"] != [NSNull null]) {
        cell.nameLabel.text = self.data[@"organizer"];
    }
    cell.subtitleLabel.text = self.data[@"organizerEmail"];
    
    return cell;
}


#pragma mark IBActions

- (IBAction)addToCalendar:(UIButton *)sender
{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not allowed");
            return;
        }
        
        
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = self.data[@"title"];
        event.location = self.data[@"location"];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy 'at' h:mm a"];
        NSDate *date = [dateFormatter dateFromString:self.data[@"date"]];
        
        
        event.startDate = date;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        event.allDay = NO;
        
        
        
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
        
        //        CGRect frame = self.attendButton.frame;
        //        frame.origin.x = frame.origin.x + 15;
        //        frame.size.width = frame.size.width - 15;
        //        self.attendButton.frame = frame;
        //        self.attendButton.titleLabel.text = @"Attending";
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
