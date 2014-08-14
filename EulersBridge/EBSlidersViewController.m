//
//  EBSlidersViewController.m
//  Isegoria
//
//  Created by Alan Gao on 11/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSlidersViewController.h"
#import "EBSliderTableViewCell.h"

@interface EBSlidersViewController () <UITableViewDataSource, UITableViewDelegate, EBPersonalitySelectionDelegate>

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
    self.degreeArray = @[@"Agree Strongly",
                         @"Agree Moderately",
                         @"Agree a Little",
                         @"Neither",
                         @"Disagree a little",
                         @"Disagree Moderately",
                         @"Disagree Strongly"];
    
    self.selectionArray = [NSMutableArray array];
    for (int i = 0; i < 10; i += 1) {
        [self.selectionArray addObject:@(3)];
    }

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
    [cell setSelectionWithIndex:[self.selectionArray[indexPath.row] intValue]];
    cell.selectionDelegate = self;
    cell.index = indexPath.row;
    return cell;
}

#pragma mark personality selection delegate
-(void)personalitySelectedWithAdjectiveIndex:(long)adjectiveIndex rateIndex:(int)rateIndex
{
    [self.selectionArray replaceObjectAtIndex:adjectiveIndex withObject:@(rateIndex)];
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    // Tabbar custom image
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"Feed Higlighted"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"Election Higlighted"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"Poll Higlighted"];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"Vote Higlighted"];
    tabBarItem5.selectedImage = [UIImage imageNamed:@"Profile Higlighted"];
    

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
