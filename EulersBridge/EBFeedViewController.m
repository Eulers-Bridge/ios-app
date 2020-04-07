//
//  EBFeedViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedViewController.h"
#import "EBFeedCollectionViewCell.h"
#import "EBFeedDetailViewController.h"
#import "MyConstants.h"
#import "EBHelper.h"
#import "EBNetworkService.h"
#import "DateTools.h"
#import "EBContentViewController.h"

@interface EBFeedViewController () <EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *customScrollView;
@property (strong, nonatomic) UIRefreshControl *newsRefreshControl;
@property (strong, nonatomic) UIRefreshControl *eventRefreshControl;
@property (strong, nonatomic) UIRefreshControl *photoRefreshControl;
@property (strong, nonatomic) NSArray *sampleDates;
@property (strong, nonatomic) NSArray *newsList;
@property (strong, nonatomic) NSArray *newsDataList;
@property (strong, nonatomic) NSArray *eventDataList;
@property (strong, nonatomic) NSArray *photoDataList;

@property (strong, nonatomic) EBNetworkService *networkService;


@end

@implementation EBFeedViewController

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
    
    // tab bar image
    
    [self.segmentedControl addTarget:self action:@selector(changeSegment) forControlEvents:UIControlEventValueChanged];
    self.newsCollectionView.alwaysBounceVertical = YES;
    self.customScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width * 3, self.customScrollView.bounds.size.height - 150);
    self.customScrollView.pagingEnabled = YES;
    self.customScrollView.alwaysBounceVertical = NO;
    self.customScrollView.delegate = self;

    // Add refresh control
    UIRefreshControl *newsControl = [[UIRefreshControl alloc] init];
    [newsControl addTarget:self action:@selector(fetchDataNews:)
             forControlEvents:UIControlEventValueChanged];
    
    UIRefreshControl *eventControl = [[UIRefreshControl alloc] init];
    [eventControl addTarget:self action:@selector(fetchDataEvent:)
                     forControlEvents:UIControlEventValueChanged];
    
    UIRefreshControl *photoControl = [[UIRefreshControl alloc] init];
    [photoControl addTarget:self action:@selector(fetchDataPhoto:)
                     forControlEvents:UIControlEventValueChanged];

    [self.newsCollectionView addSubview:newsControl];
    [self.eventsCollectionView addSubview:eventControl];
    [self.photosCollectionView addSubview:photoControl];
    self.newsRefreshControl = newsControl;
    self.eventRefreshControl = eventControl;
    self.photoRefreshControl = photoControl;

//    
//    self.eventsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//    self.newsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//    self.photosCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    
    self.eventsCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.newsCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.photosCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGRect frame0 = CGRectMake(0, 0, [EBHelper getScreenSize].width, [EBHelper getScreenSize].height);
    CGRect frame1 = frame0;
    CGRect frame2 = frame0;
    frame1.origin.x = [EBHelper getScreenSize].width;
    frame2.origin.x = [EBHelper getScreenSize].width * 2;
    
    self.newsCollectionView.frame = frame0;
    self.photosCollectionView.frame = frame1;
    self.eventsCollectionView.frame = frame2;
    
    self.sampleDates = @[@"Yesterday, 9:00 AM",
                         @"Friday, 1:00 PM",
                         @"Wednesday, 2:00 PM",
                         @"2nd May 2014, 8:00 AM",
                         @"28th April 2014, 10:00AM"];
//    self.photoDataList = @[@{@"title": @"Baillieu Library Refurbishment Unveiling",
//                             @"numberOfPhotos": @"20",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"bl"},
//                           @{@"title": @"Cocktail Party Numero Uno",
//                             @"numberOfPhotos": @"30",
//                             @"date": @"2nd May 2014, 8:00 AM",
//                             @"prefix": @"Num"},
//                           @{@"title": @"Head of the Yarra",
//                             @"numberOfPhotos": @"41",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"yarra"},
//                           @{@"title": @"Clubs & Societies Day Rocks!",
//                             @"numberOfPhotos": @"37",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"Club"},
//                           @{@"title": @"Clive Palmer Press Conference",
//                             @"numberOfPhotos": @"24",
//                             @"date": @"Wednesday, 2:00 PM",
//                             @"prefix": @"cp"},
//                           @{@"title": @"Slam Dunk Festival 2014",
//                             @"numberOfPhotos": @"33",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"slam"},
//                           @{@"title": @"Coffee at Lakeside Restaurant",
//                             @"numberOfPhotos": @"20",
//                             @"date": @"2nd May 2014, 8:00 AM",
//                             @"prefix": @"lake"},
//                           @{@"title": @"Flirt",
//                             @"numberOfPhotos": @"30",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"Flirt"},
//                           @{@"title": @"Polling Day",
//                             @"numberOfPhotos": @"20",
//                             @"date": @"28th April 2014, 10:00AM",
//                             @"prefix": @"poll"},
//                           
//                           ];
//    [self setupSampleData];
    [self fetchDataNews:self.newsRefreshControl];
    [self fetchDataPhoto:self.photoRefreshControl];
    [self fetchDataEvent:self.eventRefreshControl];
    
//    NSLog(@"size: %f %f", [EBHelper getScreenSize].width, [EBHelper getScreenSize].height);

}



- (void)changeSegment
{
    [self.customScrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * [EBHelper getScreenSize].width, 0.0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.customScrollView) {
        self.segmentedControl.selectedSegmentIndex = scrollView.contentOffset.x / [EBHelper getScreenSize].width;
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.newsCollectionView) {
        return [self.newsDataList count];
    } else if (collectionView == self.eventsCollectionView) {
        return [self.eventDataList count];
    } else if (collectionView == self.photosCollectionView) {
        return [self.photoDataList count];
    }
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.newsCollectionView) {
        
        EBContentViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        content.contentViewType = EBContentViewTypeNews;
        content.data = self.newsDataList[indexPath.item];
        [self.navigationController pushViewController:content animated:YES];
        
    } else if (collectionView == self.eventsCollectionView) {
        
        EBContentViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        content.contentViewType = EBContentViewTypeEvent;
        content.data = self.eventDataList[indexPath.item];
        [self.navigationController pushViewController:content animated:YES];
        
    } else if (collectionView == self.photosCollectionView) {
        
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EBFeedCollectionViewCell *cell;
    NSDictionary *dict;
    if (collectionView == self.newsCollectionView) {
        dict = self.newsDataList[indexPath.item];
    } else if (collectionView == self.eventsCollectionView) {
        dict = self.eventDataList[indexPath.item];
    } else if (collectionView == self.photosCollectionView) {
        dict = self.photoDataList[indexPath.item];
    }

    int priority = [dict[@"priority"] intValue];
    

    
    if (priority == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCellLarge" forIndexPath:indexPath];
        cell.feedCellType = EBFeedCellTypeLarge;
    } else if (collectionView == self.photosCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCellSmall" forIndexPath:indexPath];
        cell.feedCellType = EBFeedCellTypeSmall;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath:indexPath];
        cell.feedCellType = EBFeedCellTypeSquare;
    }
    
    // Sample no image
    if (indexPath.item == 3 && collectionView != self.photosCollectionView) {
        NSMutableDictionary *mutableDict = [dict mutableCopy];
        [mutableDict setObject:@"false" forKey:@"hasImage"];
        dict = [mutableDict copy];
    }
    
    // Sample large photo cell
    if (indexPath.item == 4 && collectionView == self.photosCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCellLarge" forIndexPath:indexPath];
        cell.feedCellType = EBFeedCellTypeLarge;
    }

    
    cell.data = dict;
//    NSLog(@"%ld", indexPath.item);
//    NSLog(@"%@", cell.data);
//    NSMutableDictionary *dict = [self.newsList[indexPath.item] mutableCopy];
//    [dict setObject:@(indexPath.item % 3 == 0 ? 1 : 0) forKey:@"priority"];
//    cell.data = [dict copy];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.index = indexPath.item;
    [cell setup];
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat smallCellWidth = ([EBHelper getScreenSize].width - 3 * SPACING_FEED) / 2;
    
    CGFloat largeCellWidth = [EBHelper getScreenSize].width - 2 * SPACING_FEED;
    
    CGSize largeCellSize = CGSizeMake(largeCellWidth, smallCellWidth);
    CGSize smallCellSize = CGSizeMake(smallCellWidth, smallCellWidth);
    CGSize photoCellSize = CGSizeMake(largeCellWidth, 50.0);
    
    if (collectionView == self.eventsCollectionView) {
        return largeCellSize;
    } else if (collectionView == self.photosCollectionView) {
        if (indexPath.item == 4) {
            return largeCellSize;
        } else {
            return photoCellSize;
        }
    } else {
        return indexPath.item % 3 == 0 ? largeCellSize : smallCellSize;
    }
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}


- (void)fetchDataNews:(UIRefreshControl *)refreshControl
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    self.networkService = service;
    service.contentDelegate = self;
    [service getNewsWithInstitutionId:TESTING_INSTITUTION_ID];
    
}

- (void)fetchDataEvent:(UIRefreshControl *)refreshControl
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getEventsWithInstitutionId:TESTING_INSTITUTION_ID];
}

- (void)fetchDataPhoto:(UIRefreshControl *)refreshControl
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getNewsFeedIdWithInstitutionId:TESTING_INSTITUTION_ID];
}

-(void)getNewsFeedIdFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        EBNetworkService *service = [[EBNetworkService alloc] init];
        service.contentDelegate = self;
        NSString *newsFeedId = info[@"nodeId"];
        [service getPhotoAlbumsWithNewsFeedId:newsFeedId];
    } else {
        
    }
}

- (void)getNewsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSArray *newsList = info[@"foundObjects"];
        NSMutableArray *newsDataList = [NSMutableArray array];
        int i = 0;
        for (NSDictionary *newsItem in newsList) {
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[newsItem[@"date"] integerValue] / 1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy, h:mm a"];
            NSString *dateAndTime = [dateFormatter stringFromDate:date];
//            NSString *ago = [date timeAgoSinceNow];
            NSArray *photoList = newsItem[@"photos"] == [NSNull null] ? [NSArray array] : newsItem[@"photos"];
            
            NSDictionary *data = @{@"priority"     : @(i % 3 == 0 ? 1 : 0),
                                   @"title"        : newsItem[@"title"],
                                   @"date"         : dateAndTime,
                                   @"hasImage"     : [photoList count] == 0 ? @"false" : @"true",
                                   @"imageName"    : [NSString stringWithFormat:@"%@%ld.jpg", @"news", (long)i],
                                   @"imageUrl"     : [photoList count] == 0 ? @"" : [photoList firstObject][@"url"],
                                   @"article"      : newsItem[@"content"],
                                   @"creatorEmail" : newsItem[@"creatorEmail"],
                                   @"likes"        : newsItem[@"likes"],
                                   @"articleId"    : newsItem[@"articleId"]
                                   };
            [newsDataList addObject:data];
            i++;
        }
        self.newsDataList = [newsDataList copy];
        [self.newsCollectionView reloadData];

    }
    [self.newsRefreshControl endRefreshing];
}

- (void)getEventsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSArray *eventsList = info[@"foundObjects"];
        NSMutableArray *eventsDataList = [NSMutableArray array];
        int i = 0;
        for (NSDictionary *eventItem in eventsList) {
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[(eventItem[@"starts"] == [NSNull null] ? eventItem[@"created"] : eventItem[@"starts"]) integerValue] / 1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy 'at' h:mm a"];
            NSString *dateAndTime = [dateFormatter stringFromDate:date];
            NSArray *photoList = eventItem[@"photos"] == [NSNull null] ? [NSArray array] : eventItem[@"photos"];
            
            NSDictionary *data = @{@"priority"      : @(1),
                                   @"title"         : eventItem[@"name"],
                                   @"date"          : dateAndTime,
                                   @"hasImage"      : [photoList count] == 0 ? @"false" : @"true",
                                   @"imageName"     : [NSString stringWithFormat:@"%@%ld.jpg", @"event", (long)i],
                                   @"imageUrl"      : [photoList count] == 0 ? @"" : [photoList firstObject][@"url"],
                                   @"article"       : eventItem[@"description"],
                                   @"location"      : eventItem[@"location"],
                                   @"organizer"     : eventItem[@"organizer"],
                                   @"organizerEmail": eventItem[@"organizerEmail"]
                                   };
            [eventsDataList addObject:data];
            i++;
        }
        self.eventDataList = [eventsDataList copy];
        [self.eventsCollectionView reloadData];
        
    }
    [self.eventRefreshControl endRefreshing];

}

-(void)getPhotoAlbumsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        NSArray *photoAlbumsList = info[@"foundObjects"];
        NSMutableArray *photoAlbumsDataList = [NSMutableArray array];
        int i = 0;
        for (NSDictionary *photoAlbumItem in photoAlbumsList) {
            if (photoAlbumItem[@"created"] == [NSNull null]) {
                continue;
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[photoAlbumItem[@"created"] integerValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy 'at' h:mm a"];
            NSString *dateAndTime = [dateFormatter stringFromDate:date];

//            NSString *subtitle = [NSString stringWithFormat:@"%d photos - %@", [self.photoDataList[indexPath.item][@"numberOfPhotos"] intValue], self.photoDataList[indexPath.item][@"date"]];
            NSDictionary *data = @{@"imageName": @"",
                                   @"imageUrl": photoAlbumItem[@"thumbNailUrl"],
                                   @"title": photoAlbumItem[@"description"],
                                   @"date": dateAndTime,
                                   @"numberOfPhotos": @"0",
                                   @"prefix": @"",
                                   @"hasImage": @"true",
                                   @"albumId": photoAlbumItem[@"nodeId"]};

            [photoAlbumsDataList addObject:data];
            i++;
        }
        self.photoDataList = [photoAlbumsDataList copy];
        [self.photosCollectionView reloadData];
        
    }
    [self.photoRefreshControl endRefreshing];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.networkService.contentDelegate = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showNewsDetail"]) {
        [[segue destinationViewController] setFeedDetailType:EBFeedDetailNews];
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        [[segue destinationViewController] setImage:cell.imageView.image];
    } else if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        [[segue destinationViewController] setFeedDetailType:EBFeedDetailEvent];
        EBFeedCollectionViewCell *cell = (EBFeedCollectionViewCell *)sender;
        [[segue destinationViewController] setImage:cell.imageView.image];
    } else if ([segue.identifier isEqualToString:@"showPhotoCollection"]) {
        [[segue destinationViewController] setFeedDetailType:EBFeedDetailPhoto];
//        [[segue destinationViewController] setPhotoIndex:[sender index]];
    }
    [[segue destinationViewController] setData:[sender data]];
}



- (void)setupSampleData
{
    // Get the titles.
    NSString* path = [[NSBundle mainBundle] pathForResource:@"newsTitles"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *newsTitleArray = [content componentsSeparatedByString:@"\n"];
    
    NSMutableArray *newsDataList = [NSMutableArray arrayWithCapacity:15];
    int i = 0;
    for (i = 0; i < 15; i += 1) {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"news%d", i]
                                                         ofType:@"txt"];
        
        content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        
        NSDictionary *data = @{@"priority"   : @(i % 3 == 0 ? 1 : 0),
                               @"title"      : newsTitleArray[i],
                               @"date"       : self.sampleDates[i%5],
                               @"hasImage"   : @"true",
                               @"imageName"  : [NSString stringWithFormat:@"%@%ld.jpg", @"news", (long)i],
                               @"article"    : content
                               };
        [newsDataList addObject:data];


    }
    self.newsDataList = [newsDataList copy];
    
    
    // Events
    path = [[NSBundle mainBundle] pathForResource:@"eventTitles"
                                           ofType:@"txt"];
    
    content = [NSString stringWithContentsOfFile:path
                                        encoding:NSUTF8StringEncoding
                                           error:NULL];
    NSArray *eventsTitleArray = [content componentsSeparatedByString:@"\n"];

    NSMutableArray *eventDataList = [NSMutableArray arrayWithCapacity:8];
    for (i = 0; i < 8; i += 1) {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"event%d", i]
                                               ofType:@"txt"];
        
        content = [NSString stringWithContentsOfFile:path
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];
        
        NSDictionary *data = @{@"priority"   : @(1),
                               @"title"      : eventsTitleArray[i],
                               @"date"       : self.sampleDates[i%5],
                               @"hasImage"   : @"true",
                               @"imageName"  : [NSString stringWithFormat:@"%@%ld.jpg", @"event", (long)i],
                               @"article"    : content
                               };
        [eventDataList addObject:data];
        
        
    }
    self.eventDataList = [eventDataList copy];
}

@end
