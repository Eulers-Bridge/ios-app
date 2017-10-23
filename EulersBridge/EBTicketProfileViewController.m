//
//  EBTicketProfileViewController.m
//  Isegoria
//
//  Created by Alan Gao on 3/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTicketProfileViewController.h"
#import "EBBlurImageView.h"
#import "EBCandidateTableViewController.h"
#import "EBTicketCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface EBTicketProfileViewController ()

@property (weak, nonatomic) IBOutlet EBBlurImageView *backgroundPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *institutionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;

@end

@implementation EBTicketProfileViewController

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
    self.nameLabel.text = self.ticketData[@"name"];
    self.backgroundPhoto.image = [UIImage imageNamed:@"Ticket Background"];
    if ([self.ticketData[@"photos"] count] != 0) {
        [self.profilePhoto setImageWithURL:[NSURL URLWithString:self.ticketData[@"photos"][0][@"url"]]];
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
    if ([segue.identifier isEqualToString:@"CandidateFromTicketProfileEmbed"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByTicket;
        tvc.filterId = [self.ticketData[@"ticketId"] intValue];
        tvc.filterTitle = self.ticketData[@"name"];
        tvc.candidates = self.candidates;
        tvc.tickets = self.tickets;
        tvc.positions = self.positions;
    }
}


@end
