//
//  EBPollContentViewController.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPollContentViewController.h"
#import "EBPollAnswerTableViewCell.h"
#import "EBPollCommentTableViewCell.h"
#import "MyConstants.h"

@interface EBPollContentViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet EBTextViewMuseoMedium *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainerView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
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
//    self.profileImageView.image = [UIImage imageNamed:@"head1.jpg"];
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
    
    
    // Gesture Recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAnywhere)];
    self.tapGestureRecognizer = tap;
    self.panGestureRecognizer = pan;
    
}

#pragma mark table view delegate and data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 5;
            
        default:
            return 4;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
        cell.backgroundColor = ISEGORIA_ULTRA_LIGHT_GREY;
        return cell;
    } else if (indexPath.section == 1) {
        EBPollCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 47;
            break;
        case 1:
            return 110;
            break;
        default:
            return 47;
            break;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.voted = YES;
        self.selectedIndexPath = indexPath;
        [self.answerTableView reloadData];
        
        return indexPath;
    }
    return nil;
}


#pragma mark textField delegate

- (BOOL)textViewShouldBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self pushContentUpWithCompletion:nil];
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextField *)textField
{
    return NO;
}


#pragma mark tap gesture

- (void)tapAnywhere
{
    [self dismissKeyboard];
    [self pushContentDown];
}

-(void)dismissKeyboard {
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
    [self.commentTextView resignFirstResponder];
}


#pragma mark animation
- (void)pushContentUpWithCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.textFieldContainerView.frame;
        frame.origin.y = frame.origin.y - 267;
        frame.size.height = frame.size.height + 100;
        self.textFieldContainerView.frame = frame;
    } completion:completion];
}

- (void)pushContentDown
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.textFieldContainerView.frame;
        frame.origin.y = frame.origin.y + 267;
        frame.size.height = frame.size.height - 100;
        self.textFieldContainerView.frame = frame;
    } completion:^(BOOL finished) {
        
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
