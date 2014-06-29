//
//  EBTicketsCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTicketsCollectionViewController.h"
#import "EBTicketCollectionViewCell.h"
#import "EBCandidateTableViewController.h"

@interface EBTicketsCollectionViewController ()

@end

@implementation EBTicketsCollectionViewController

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
    self.tickets = @[@{@"id": @"0",
                       @"title": @"Stand Up!",
                       @"supporters": @"890",
                       @"colorRGB": @{@"R": @"255",
                                      @"G": @"59",
                                      @"B": @"48"}},
                     @{@"id": @"1",
                       @"title": @"Activate",
                       @"supporters": @"560",
                       @"colorRGB": @{@"R": @"82",
                                      @"G": @"128",
                                      @"B": @"213"}},
                     @{@"id": @"2",
                       @"title": @"More Activities!",
                       @"supporters": @"480",
                       @"colorRGB": @{@"R": @"245",
                                      @"G": @"166",
                                      @"B": @"35"}},
                     @{@"id": @"3",
                       @"title": @"Change.",
                       @"supporters": @"690",
                       @"colorRGB": @{@"R": @"76",
                                      @"G": @"217",
                                      @"B": @"100"}},
                     @{@"id": @"4",
                       @"title": @"Indepnedent Media",
                       @"supporters": @"520",
                       @"colorRGB": @{@"R": @"121",
                                      @"G": @"121",
                                      @"B": @"144"}},
                     @{@"id": @"5",
                       @"title": @"F*ck the Cuts",
                       @"supporters": @"390",
                       @"colorRGB": @{@"R": @"62",
                                      @"G": @"90",
                                      @"B": @"215"}},
                     @{@"id": @"6",
                       @"title": @"Voice",
                       @"supporters": @"360",
                       @"colorRGB": @{@"R": @"248",
                                      @"G": @"118",
                                      @"B": @"118"}},
                     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    NSDictionary *data = self.tickets[indexPath.item];
    cell.ticketId = [data[@"id"] intValue];
    cell.titleLabel.text = data[@"title"];
    cell.subtitleLabel.text = [data[@"supporters"] stringByAppendingString:@" supporters"];
    NSDictionary *color = data[@"colorRGB"];
    CGFloat red = [color[@"R"] floatValue];
    CGFloat green = [color[@"G"] floatValue];
    CGFloat blue = [color[@"B"] floatValue];
    UIColor *backColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
//    cell.backView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    cell.backView.backgroundColor = backColor;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCandidateFromTicket"]) {
        EBCandidateTableViewController *tvc = (EBCandidateTableViewController *)[segue destinationViewController];
        tvc.candidateFilter = EBCandidateFilterByTicket;
        EBTicketCollectionViewCell *cell = (EBTicketCollectionViewCell *)sender;
        tvc.filterId = cell.ticketId;
        tvc.filterTitle = cell.titleLabel.text;
    }
}

@end
