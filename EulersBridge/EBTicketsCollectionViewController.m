//
//  EBTicketsCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 27/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTicketsCollectionViewController.h"
#import "EBTicketCollectionViewCell.h"
#import "EBTicketProfileViewController.h"
#import "MyConstants.h"
#import "EBHelper.h"
#import "EBNetworkService.h"
#import "EBContentViewController.h"

@interface EBTicketsCollectionViewController () <EBContentServiceDelegate>

@property BOOL ticketDataReady;
@property BOOL positionDataReady;
@property BOOL candidateDataReady;

@property (strong, nonatomic) NSArray *sampleTickets;

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
   
    // Reigster for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTicketData:) name:@"TicketsReturnedFromServer" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPositionData:) name:@"PositionsReturnedFromServer" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCandidateData:) name:@"CandidatesReturnedFromServer" object:nil];
    
    self.sampleTickets = @[@{@"id": @"0",
                       @"title": @"Greens Students",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"248",
                                      @"G": @"118",
                                      @"B": @"118"}},
                     @{@"id": @"1",
                       @"title": @"Liberty",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"82",
                                      @"G": @"128",
                                      @"B": @"213"}},
                     @{@"id": @"2",
                       @"title": @"STAR",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"245",
                                      @"G": @"166",
                                      @"B": @"35"}},
                     @{@"id": @"3",
                       @"title": @"Young Labor",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"255",
                                      @"G": @"59",
                                      @"B": @"48"}},
                     @{@"id": @"4",
                       @"title": @"Young Liberal",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"121",
                                      @"G": @"121",
                                      @"B": @"144"}},
                     @{@"id": @"5",
                       @"title": @"Socialist Alternative",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"62",
                                      @"G": @"90",
                                      @"B": @"215"}},
                     @{@"id": @"6",
                       @"title": @"Voice",
                       @"supporters": @"1240",
                       @"colorRGB": @{@"R": @"76",
                                      @"G": @"217",
                                      @"B": @"100"}},
                     ];
    
    
    
    self.ticketDataReady = NO;
    self.positionDataReady = NO;
    self.candidateDataReady = NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refreshTicketData:(NSNotification *)notification
{
    self.tickets = (NSArray *)notification.userInfo[@"foundObjects"];
    self.ticketDataReady = YES;
    [self.collectionView reloadData];
}

- (void)refreshPositionData:(NSNotification *)notification
{
    self.positions = (NSArray *)notification.userInfo[@"foundObjects"];
    self.positionDataReady = YES;
}

- (void)refreshCandidateData:(NSNotification *)notification
{
    self.candidates = (NSArray *)notification.userInfo[@"foundObjects"];
    self.candidateDataReady = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tickets count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCell" forIndexPath:indexPath];
    NSDictionary *data = self.tickets[indexPath.item];
    cell.ticketId = [data[@"ticketId"] intValue];
    cell.titleLabel.text = data[@"name"];
    cell.subtitleLabel.text = [[data[@"numberOfSupporters"] stringValue] stringByAppendingString:@" supporters"];
    
    UIColor *backColor;
    if (data[@"colour"] != [NSNull null]) {
        backColor = UIColorFromRGB([EBHelper hexFromString:[data[@"colour"] substringFromIndex:1]]);
    } else {
        backColor = [UIColor grayColor];
    }
    // Temp fix.
//    NSDictionary *color = self.sampleTickets[indexPath.item][@"colorRGB"];
//    CGFloat red = [color[@"R"] floatValue];
//    CGFloat green = [color[@"G"] floatValue];
//    CGFloat blue = [color[@"B"] floatValue];
//    UIColor *backColor = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1.0];
    cell.backView.backgroundColor = ISEGORIA_ULTRA_LIGHT_GREY;
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [backColor CGColor];
    cell.titleLabel.textColor = backColor;
    cell.subtitleLabel.textColor = backColor;
    cell.ticketData = self.tickets[indexPath.item];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = ([EBHelper getScreenSize].width - 3 * SPACING_FEED) / 2;
    return CGSizeMake(cellWidth, cellWidth);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ticketDataReady && self.candidateDataReady && self.positionDataReady) {
        
        EBContentViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        content.contentViewType = EBContentViewTypeTicketProfile;
        content.data = self.tickets[indexPath.item];
        content.candidates = self.candidates;
        content.tickets = self.tickets;
        content.positions = self.positions;
        [self.navigationController pushViewController:content animated:YES];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Data not ready" message:@"Please wait while we are getting data from the server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        
    }
    
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowTicketProfile"] && self.ticketDataReady && self.candidateDataReady && self.positionDataReady) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Data not ready" message:@"Please wait while we are getting data from the server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return NO;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTicketProfile"]) {
        EBTicketProfileViewController *ticketProfile = (EBTicketProfileViewController *)[segue destinationViewController];
        EBTicketCollectionViewCell *cell = (EBTicketCollectionViewCell *)sender;
        ticketProfile.ticketData = cell.ticketData;
        ticketProfile.candidates = self.candidates;
        ticketProfile.tickets = self.tickets;
        ticketProfile.positions = self.positions;

    }
}


@end
