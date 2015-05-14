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

@interface EBFeedDetailViewController () <EKEventEditViewDelegate, UIScrollViewDelegate, NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet EBLabelLight *likesLabel;
@property (weak, nonatomic) IBOutlet EBButtonRoundedHeavy *attendButton;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet EBOnePixelLine *separator;
@property (weak, nonatomic) IBOutlet UIView *darkBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *eventLocationSecondLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *eventContactName;
@property (weak, nonatomic) IBOutlet EBLabelMedium *eventContactDetail;

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
    self.textView.layoutManager.delegate = self;
    // Do any additional setup after loading the view.
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.detailScrollView.delegate = self;
    self.detailScrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    
    // Setup the mask
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.imageView.frame;
    gradient.bounds = CGRectMake(0, 0, [EBHelper getScreenSize].width, [EBHelper getScreenSize].height);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.35] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.35] CGColor], nil];
    gradient.locations = @[@(0.0), @(1.0)];
    gradient.masksToBounds = YES;
    self.imageView.layer.mask = gradient;
    
    // Setup Font
    self.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_TITLE];
    
    CGFloat offset = 0.0;
    if (self.feedDetailType == EBFeedDetailNews) {
        [self setupNews];
        self.likes = 205;
        self.separator.hidden = YES;
        offset = 50;
    } else if (self.feedDetailType == EBFeedDetailEvent) {
        [self setupEvent];
        offset = 44.0;
        self.separator.hidden = NO;
    }
    
    
    
    CGSize size = [self.textView sizeThatFits:CGSizeMake([EBHelper getScreenSize].width, 100)];
    self.textView.frame = CGRectMake(15,
                                     self.imageView.bounds.size.height + offset,
                                     [EBHelper getScreenSize].width - 30,
                                     size.height);
    self.whiteBackgroundView.frame = CGRectMake(0, self.whiteBackgroundView.frame.origin.y, [EBHelper getScreenSize].width, size.height);
    
    CGRect contactFrame = self.contactView.frame;
    contactFrame.origin.y = self.imageView.bounds.size.height + self.textView.frame.size.height + offset;
    self.contactView.frame = contactFrame;
    
    CGRect separatorFrame = self.separator.frame;
    separatorFrame.origin.y = contactFrame.origin.y + 25;
    self.separator.frame = separatorFrame;
    
    self.detailScrollView.contentSize = CGSizeMake([EBHelper getScreenSize].width,
                                             self.imageView.bounds.size.height + self.textView.frame.size.height + offset + self.contactView.bounds.size.height + 40);

    

    
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 4;
}


- (void)setupNews
{
    self.dateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_DATE];
    self.authorLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_ARTICLE_AUTHOR];
    
    self.titleLabel.text = self.data[@"title"];
    self.authorLabel.text = @"Eva Menendez";
    self.dateLabel.text = self.data[@"date"];
    if (!self.image) {
        self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
    } else {
        self.imageView.image = self.image;
    }
    self.authorImageView.image = [UIImage imageNamed:@"head1.jpg"];
    self.authorImageView.layer.cornerRadius = 12;
    self.textView.text = self.data[@"article"];
    self.likes = 205;
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.likes];
}

- (void)setupEvent
{
    self.dateLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_EVENT_DATE];
    self.titleLabel.text = self.data[@"title"];
    self.dateLabel.text = self.data[@"date"];
    if (!self.image) {
        self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
    } else {
        self.imageView.image = self.image;
        self.eventLocationLabel.text = self.data[@"location"];
        self.eventLocationSecondLabel.text = self.data[@"location"];
        self.eventContactName.text = self.data[@"organizer"];
        self.eventContactDetail.text = self.data[@"organizerEmail"];
    }
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

#pragma mark IBActions

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
    if (action == EKEventEditViewActionSaved) {

//        CGRect frame = self.attendButton.frame;
//        frame.origin.x = frame.origin.x + 15;
//        frame.size.width = frame.size.width - 15;
//        self.attendButton.frame = frame;
//        self.attendButton.titleLabel.text = @"Attending";
    }
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

- (IBAction)like:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    self.likes += (sender.selected?1:-1);
    self.likesLabel.text = [NSString stringWithFormat:@"%d", self.likes];
}

- (IBAction)flag:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}


#pragma mark Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.detailScrollView) {
        CGRect frame = self.imageView.frame;
        CGRect backFrame = self.darkBackgroundView.frame;
        if (scrollView.contentOffset.y > -64) {
            frame.origin.y = (scrollView.contentOffset.y + 64) * 0.2;
        } else {
            frame.origin.y = (scrollView.contentOffset.y + 64);
            frame.size.height = -(scrollView.contentOffset.y + 64) + 229;
            backFrame.size.height = frame.size.height;
        }
        self.imageView.frame = frame;
        self.darkBackgroundView.frame = backFrame;
//        self.imageView.layer.mask.position = CGPointMake(frame.size.width/2, frame.origin.y +200 + frame.size.height/2);
//        self.imageView.layer.mask.bounds = CGRectMake(0, 0, 150,800);
    }
    
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
