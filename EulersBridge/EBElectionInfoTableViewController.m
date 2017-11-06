//
//  EBElectionInfoTableViewController.m
//  Isegoria
//
//  Created by Alan Gao on 14/04/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBElectionInfoTableViewController.h"
#import "EBNetworkService.h"
#import "EBHelper.h"
#import "EBTextViewHelvetica.h"

@interface EBElectionInfoTableViewController () <EBContentServiceDelegate, NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet EBLabelMedium *electionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;
@property (strong, nonatomic) EBTextViewHelvetica *overviewTextView;
@property (strong, nonatomic) EBTextViewHelvetica *processTextView;

@end

@implementation EBElectionInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.overviewTextView = [[EBTextViewHelvetica alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.processTextView = [[EBTextViewHelvetica alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.overviewTextView.scrollEnabled = NO;
    self.overviewTextView.editable = NO;
    self.processTextView.scrollEnabled = NO;
    self.processTextView.editable = NO;

    [self getElectionInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getElectionInfo
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getElectionsInfoWithInstitutionId:TESTING_INSTITUTION_ID];
}

-(void)getElectionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        EBNetworkService *service = [[EBNetworkService alloc] init];
        service.contentDelegate = self;
        NSArray *array = info[@"foundObjects"];
        if (array.count > 0) {
            NSString *electionId = info[@"foundObjects"][0][@"electionId"];
            [service getElectionInfoWithElectionId:electionId];
        }
    } else {
        
    }
}

-(void)getElectionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.electionTitleLabel.text = (info[@"title"] == [NSNull null] ? @"" : info[@"title"]);
        self.overviewTextView.text = (info[@"introduction"] == [NSNull null] ? @"" : info[@"introduction"]);
        self.processTextView.text = (info[@"process"] == [NSNull null] ? @"" : info[@"process"]);
        [EBHelper resetTextView:self.overviewTextView];
        [EBHelper resetTextView:self.processTextView];
        [self.tableView reloadData];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"startVoting"] integerValue] / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy, 'Ballot opens' h:mm a"];
        NSString *dateAndTime = [dateFormatter stringFromDate:date];
        self.electionDateLabel.text = dateAndTime;
        
    } else {
        
    }
}


#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) {
        title = @"OVERVIEW";
    } else if (section == 1) {
        title = @"ELECTION PROCESS";
    }
    
    UIView *view = [EBHelper sectionTitleViewWithEnclosingView:tableView andText:title];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_TITLE_VIEW_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.overviewTextView.frame.size.height;
    } else if (indexPath.section == 1) {
        return self.processTextView.frame.size.height;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ElectionInfoCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.overviewTextView];
    } else if (indexPath.section == 1) {
        [cell.contentView addSubview:self.processTextView];
    }
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
