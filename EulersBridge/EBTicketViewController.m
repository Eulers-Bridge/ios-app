//
//  EBTicketViewController.m
//  Isegoria
//
//  Created by Alan Gao on 16/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBTicketViewController.h"
#import "EBCandidateTableViewController.h"
#import "EBNetworkService.h"
#import "EBUserService.h"

@interface EBTicketViewController () <EBUserActionServiceDelegate, EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet EBLabelHeavy *supportersNumberLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *memberNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) EBCandidateTableViewController *candidateTableView;
@property BOOL supported;


@end

@implementation EBTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.supported = NO;
}

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
    self.supportersNumberLabel.text = [data[@"numberOfSupporters"] stringValue];
    if (self.candidateTableView != nil) {
        self.candidateTableView.candidateFilter = EBCandidateFilterByTicket;
        self.candidateTableView.candidateViewType = EBCandidateViewTypeTicketProfile;
        self.candidateTableView.filterId = [self.data[@"ticketId"] intValue];
        self.candidateTableView.filterTitle = self.data[@"name"];
        self.candidateTableView.candidates = self.candidates;
        self.candidateTableView.tickets = self.tickets;
        self.candidateTableView.positions = self.positions;
        [self.candidateTableView setup];
        self.memberNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.candidateTableView.matchingCandidates.count];
        [self getSupportsWithTicketId:self.data[@"ticketId"]];
    }
}

- (void)getSupportsWithTicketId:(NSString *)ticketId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getSupportsWithTicketId:ticketId];
}

- (IBAction)supportTicketAction:(UIButton *)sender {
    self.supportButton.enabled = NO;
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userActionDelegate = self;
    [service supportTicketWithSupport:!self.supported ticketId:self.data[@"ticketId"]];
}

-(void)getTicketSupportersFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.supportersNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)((NSArray *)info).count];
        BOOL found = NO;
        for (NSDictionary *support in info) {
            if ([support[@"email"] isEqualToString:[EBUserService retriveUserEmail]]) {
                self.supported = YES;
                [self.supportButton setTitle:@"Supported" forState:UIControlStateNormal];
                found = YES;
                break;
            }
        }
        if (found == NO) {
            self.supported = NO;
            [self.supportButton setTitle:@"Support" forState:UIControlStateNormal];
        }
        self.supportButton.enabled = YES;
    } else {
        
    }
}

- (void)supportTicketFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error {
    if (success) {
        [self getSupportsWithTicketId:self.data[@"ticketId"]];
    } else {
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketViewEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        self.candidateTableView = tvc;
    }
}

@end
