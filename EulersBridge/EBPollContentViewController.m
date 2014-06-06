//
//  EBPollContentViewController.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPollContentViewController.h"
#import "EBPollAnswerTableViewCell.h"

@interface EBPollContentViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property BOOL voted;

@end

@implementation EBPollContentViewController

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
    self.voted = NO;
    self.profileImageView.image = [UIImage imageNamed:@"head1.jpg"];
    self.authorLabel.text = @"Asked by Eva Menendez";
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%d", self.pageIndex];
    self.results = @[@{@"votes": @(18),
                       @"totalVotes": @(100),
                       @"change": @(-4)},
                     @{@"votes": @(29),
                       @"totalVotes": @(100),
                       @"change": @(2)},
                     @{@"votes": @(16),
                       @"totalVotes": @(100),
                       @"change": @(-5)},
                     @{@"votes": @(37),
                       @"totalVotes": @(100),
                       @"change": @(23)},];
    
    self.answers = @[@{@"title": @"Liberal Party",
                       @"subtitle": @"Tony Abbot"},
                     @{@"title": @"Australian Labor Party",
                       @"subtitle": @"Bill Shorten"},
                     @{@"title": @"The Greens",
                       @"subtitle": @"Christine Milne"},
                     @{@"title": @"Other",
                       @"subtitle": @"Other"}];
    
    self.baseColors = @[
                        [UIColor colorWithRed:62.0/255.0 green:90.0/255.0 blue:215.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:255.0/255.0 green:64.0/255.0 blue:99.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0],
                        [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0]
                        ];
}

#pragma mark table view delegate and data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBPollAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PollAnswerCell" forIndexPath:indexPath];
    cell.resultNumberLabel.hidden = YES;
    cell.result = self.results[indexPath.row];
    cell.answer = self.answers[indexPath.row];
    cell.baseColor = self.baseColors[indexPath.row];
    [cell refreshData];
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.voted = YES;
    } else {
        cell.voted = NO;
    }
    if (self.voted) {
        cell.resultNumberLabel.hidden = NO;
        [cell showResult];
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.voted = YES;
    self.selectedIndexPath = indexPath;
    [self.answerTableView reloadData];
    
    return indexPath;
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
