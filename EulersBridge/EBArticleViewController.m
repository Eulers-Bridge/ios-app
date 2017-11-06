//
//  EBArticleViewController.m
//  Isegoria
//
//  Created by Alan Gao on 28/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBArticleViewController.h"
#import "EBTextViewHelvetica.h"
#import "EBHelper.h"
#import "UIImageView+AFNetworking.h"
#import "EBNetworkService.h"
#import "EBUserService.h"

@interface EBArticleViewController () <EBContentServiceDelegate, EBUserActionServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet EBTextViewHelvetica *textView;
@property (weak, nonatomic) IBOutlet EBLabelMedium *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property BOOL liked;

@end

@implementation EBArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.liked = NO;
}

- (void)setupData:(NSDictionary *)data
{
    self.data = data;
    self.dateLabel.text = data[@"date"];
    self.textView.text = data[@"article"];
    self.likesLabel.text = [data[@"likes"] stringValue];
    CGFloat oldHeight = self.textView.frame.size.height;
    [EBHelper resetTextView:self.textView];
    CGFloat textViewExtraHeight = fmaxf(self.textView.frame.size.height - oldHeight, 0);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + textViewExtraHeight);
    self.likeButton.enabled = NO;
    [self getLikesWithArticleId:data[@"articleId"]];
}

- (void)setupAuthorData:(NSDictionary *)data
{
//    NSString *urlString = data[@"profilePhoto"][@"thumbNailUrl"];
    NSString *urlString = data[@"profilePhoto"];
    if ([urlString class] != [NSNull class]) {
        [self.authorImageView setImageWithURL:[NSURL URLWithString:urlString]];
    }
    self.authorLabel.text = [EBHelper fullNameWithUserObject:data];
}

- (void)getLikesWithArticleId:(NSString *)articleId
{
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.contentDelegate = self;
    [service getNewsLikesWithArticleId:articleId];
}

-(void)getNewsLikesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        self.likesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)((NSArray *)info).count];
        BOOL found = NO;
        for (NSDictionary *like in info) {
            if ([like[@"email"] isEqualToString:[EBUserService retriveUserEmail]]) {
                self.liked = YES;
                found = YES;
                break;
            }
        }
        if (found == NO) {
            self.liked = NO;
        }
        self.likeButton.enabled = YES;
    } else {
        
    }
}

- (IBAction)like:(id)sender
{
    self.likeButton.enabled = NO;
    EBNetworkService *service = [[EBNetworkService alloc] init];
    service.userActionDelegate = self;
    [service likeContentWithLike:!self.liked contentType:EBContentViewTypeNews contentId:self.data[@"articleId"]];
}

-(void)likeContentFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [self getLikesWithArticleId:self.data[@"articleId"]];
    } else {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
