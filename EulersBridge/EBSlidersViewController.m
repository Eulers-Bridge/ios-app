//
//  EBSlidersViewController.m
//  Isegoria
//
//  Created by Alan Gao on 11/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSlidersViewController.h"
#import "EBSliderTableViewCell.h"
#import "EBAppDelegate.h"
#import "EBNetworkService.h"
#import "EBEmailVerificationViewController.h"

@interface EBSlidersViewController () <UITableViewDataSource, UITableViewDelegate, EBPersonalitySelectionDelegate, EBUserServiceDelegate>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *degreeArray;
@property (strong, nonatomic) NSMutableArray *selectionArray;


@end

@implementation EBSlidersViewController

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
    self.titleArray = @[@"Extraverted, enthusiastic",
                        @"Critical, quarrelsome",
                        @"Dependable, self-disciplined",
                        @"Anxious, easily upset",
                        @"Open to new experiences, complex",
                        @"Reserved, quiet",
                        @"Sympathetic, warm",
                        @"Disorganized, careless",
                        @"Calm, emotionally stable",
                        @"Conventional, uncreative"];
    self.degreeArray = @[@"Disagree Strongly",
                         @"Disagree Moderately",
                         @"Disagree a Little",
                         @"Neither",
                         @"Agree a little",
                         @"Agree Moderately",
                         @"Agree Strongly"];
    
    self.selectionArray = [NSMutableArray array];
    for (int i = 0; i < 10; i += 1) {
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SliderCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.degreeTitles = self.degreeArray;
    cell.selectionDelegate = self;
    cell.index = indexPath.row;
    cell.numChoice = 7;
    [cell setSelectionWithIndex:[self.selectionArray[indexPath.row] intValue]];
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
         @"extroversion" : [@(([a[0] floatValue] + (8 - [a[5] floatValue])) / 2) stringValue],
         @"agreeableness" : [@(([a[6] floatValue] + (8 - [a[1] floatValue])) / 2) stringValue],
         @"conscientiousness" : [@(([a[2] floatValue] + (8 - [a[7] floatValue])) / 2) stringValue],
         @"emotionalStability" : [@(([a[8] floatValue] + (8 - [a[3] floatValue])) / 2) stringValue],
         @"openess" : [@(([a[4] floatValue] + (8 - [a[9] floatValue])) / 2) stringValue]
     };
    
    
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userDelegate = self;
    [service addPersonalityForUser:self.user withParameters:parameters];
}

-(void)addPersonalityForUserFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error
{
    if (success) {
        EBAppDelegate *delegate = (EBAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate instantiateTabBarController];
    } else {
        
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
