//
//  EBNewsDetailViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedDetailViewController.h"
#import "EBHelper.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Social/Social.h>

@interface EBFeedDetailViewController () <EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end

@implementation EBFeedDetailViewController

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
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Setup the mask
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.imageView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.2] CGColor], nil];
    gradient.locations = @[@(0.35), @(1.0)];
    self.imageView.layer.mask = gradient;
    
    // Setup Font
    self.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_TITLE];
    self.actionButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:FONT_SIZE_BUTTON];
    self.textView.font = [UIFont fontWithName:@"GentiumBookBasic" size:FONT_SIZE_ARTICLE_BODY];
    
    // Action button
    self.actionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (self.feedDetailType == EBFeedDetailNews) {
        [self setupNews];
    } else if (self.feedDetailType == EBFeedDetailEvent) {
        [self setupEvent];
    }
    
    
    
    CGSize size = [self.textView sizeThatFits:CGSizeMake(WIDTH_OF_SCREEN, 200)];
    self.textView.frame = CGRectMake(0.0,
                                     self.imageView.bounds.size.height,
                                     WIDTH_OF_SCREEN,
                                     size.height);
    
    self.scrollView.contentSize = CGSizeMake(WIDTH_OF_SCREEN,
                                             self.imageView.bounds.size.height + self.textView.frame.size.height);

    

    
}


- (void)setupNews
{
    self.dateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_DATE];
    self.authorLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_AUTHOR];
    
    self.titleLabel.text = self.data[@"title"];
    self.authorLabel.text = @"Eva Menendez";
    self.dateLabel.text = self.data[@"date"];
    self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
    self.authorImageView.image = [UIImage imageNamed:@"head1.jpg"];
    self.authorImageView.layer.cornerRadius = 12;
    self.textView.text = self.data[@"article"];
}

- (void)setupEvent
{
    self.dateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_EVENT_DATE];
    self.titleLabel.text = self.data[@"title"];
    self.dateLabel.text = self.data[@"date"];
    self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
    self.textView.text = self.data[@"article"];
}

- (void)setupData
{
//    self.titleLabel.text = self.data[@"title"];
//    self.authorLabel.text = self.data[@"author"];
//    self.dateLabel.text = self.data[@"date"];
//    self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
//    self.authorImageView.image = [UIImage imageNamed:self.data[@"authorImage"]];
//    self.textView.text = self.data[@"article"];
    
    
    
}


- (IBAction)addToCalendar:(UIButton *)sender
{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Not allowed");
            return;
        }
        
        
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Election event on campus";
        event.location = @"University of Melbourne Union House";
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd HHmm"];
        NSDate *date = [formatter dateFromString:@"20140426 2100"];
        
        
        event.startDate = date;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        event.allDay = NO;
        
        
        
        EKEventEditViewController *evc = [[EKEventEditViewController alloc] init];
        evc.editViewDelegate = self;
        evc.eventStore = store;
        evc.event = event;
        [self presentViewController:evc animated:YES completion:nil];
        
    }];


    
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareOnFacebook:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *fbPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPost setInitialText:@"This is a test post from our app."];
        [fbPost addImage:[UIImage imageNamed:@"placeholder"]];
        [self presentViewController:fbPost animated:YES completion:nil];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login Facebook in settings -> Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}


- (IBAction)shareOnTwitter:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:@"This is a test post from our app."];
        [tweet addImage:[UIImage imageNamed:@"placeholder"]];
        
        [self presentViewController:tweet animated:YES completion:nil];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login Twitter in settings -> Twitter" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

- (IBAction)share:(UIBarButtonItem *)sender
{
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[@"share string"] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:^{
        
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
