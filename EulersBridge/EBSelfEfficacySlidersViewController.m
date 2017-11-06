//
//  EBSlidersViewController.m
//  Isegoria
//
//  Created by Alan Gao on 11/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSelfEfficacySlidersViewController.h"
#import "EBSliderTableViewCell.h"
#import "EBAppDelegate.h"
#import "EBNetworkService.h"
#import "EBUserService.h"
#import "EBEmailVerificationViewController.h"

@interface EBSelfEfficacySlidersViewController () <UITableViewDataSource, UITableViewDelegate, EBPersonalitySelectionDelegate, EBUserServiceDelegate>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *degreeArray;
@property (strong, nonatomic) NSMutableArray *selectionArray;


@end

@implementation EBSelfEfficacySlidersViewController

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
    self.titleArray = @[@"Promote public initiatives to support political programs that you believe are just",
                        @"Maintain personal relationships with representatives of national government authorities",
                        @"Promote effective activities of information and mobilization in your own community (of work, friends, and family), to sustain political programs in which you believe",
                        @"Use the means you have as a citizen to critically monitor the actions of your political representatives"];
    self.degreeArray = @[@"Not at all",
                         @"Somewhat unlikely",
                         @"Neutral",
                         @"Somewhat likely",
                         @"Completely"];
    
    self.selectionArray = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i += 1) {
        [self.selectionArray addObject:@(3)];
    }
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;

}

#pragma mark Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SliderCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.degreeTitles = self.degreeArray;
    [cell setSelectionWithIndex:[self.selectionArray[indexPath.row] intValue]];
    cell.selectionDelegate = self;
    cell.index = indexPath.row;
    cell.numChoice = 5;
    return cell;
}

#pragma mark personality selection delegate
-(void)personalitySelectedWithAdjectiveIndex:(long)adjectiveIndex rateIndex:(int)rateIndex
{
    [self.selectionArray replaceObjectAtIndex:adjectiveIndex withObject:@(rateIndex)];
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
//    [self performSegueWithIdentifier:@"ShowEmailFromPersonality" sender:self];
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:self.selectionArray.count];
    for (NSNumber *number in self.selectionArray) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
        [a addObject:[decimal decimalNumberByAdding:[NSDecimalNumber one]]];
    }
//    NSDictionary *parameters = @{
//        @"extroversion" : @(([a[0] floatValue] + (8 - [a[5] floatValue])) / 2),
//        @"agreeableness" : @(([a[6] floatValue] + (8 - [a[1] floatValue])) / 2),
//        @"conscientiousness" : @(([a[2] floatValue] + (8 - [a[7] floatValue])) / 2),
//        @"emotionalStability" : @(([a[8] floatValue] + (8 - [a[3] floatValue])) / 2),
//        @"openess" : @(([a[4] floatValue] + (8 - [a[9] floatValue])) / 2)
//    };
    
    NSDictionary *parameters = @{
         @"q1" : [a[0] stringValue],
         @"q2" : [a[1] stringValue],
         @"q3" : [a[2] stringValue],
         @"q4" : [a[3] stringValue]
     };
    
    
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    [service addEfficacyForUser:self.user withParameters:parameters];
}

-(void)addEfficacyForUserFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error
{
    if (success) {
        [EBUserService setHasPPSEQuestions:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Successful" message:@"Answers submitted successfully." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[self navigationController] popViewControllerAnimated:true];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:NULL];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Sorry, request failed, please resubmit." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[self navigationController] popViewControllerAnimated:true];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:NULL];
    }
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
    if ([segue.identifier isEqualToString:@"ShowEmailFromPersonality"]) {
        EBEmailVerificationViewController *email = (EBEmailVerificationViewController *)[segue destinationViewController];
        email.user = self.user;
    }
}

@end
