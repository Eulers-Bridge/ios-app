//
//  EBPollViewController.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPollViewController.h"
#import "EBPollContentViewController.h"
#import "EBPersonalityViewController.h"

@interface EBPollViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *contentViewControllers;
@property (strong, nonatomic) EBLabelMedium *titleLabel;
@property (strong, nonatomic) UIPageControl *titlePageControl;
@property int maxPoll;
@property int nextViewControllerIndex;
@end

@implementation EBPollViewController

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
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    self.maxPoll = 5;
    self.nextViewControllerIndex = 0;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PollPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
    EBLabelMedium *titleLabel = [[EBLabelMedium alloc] initWithFrame:CGRectMake(0, 5, 200, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Current Polls";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(70, 20, 50, 24)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.enabled = NO;
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:pageControl];
    
    self.titleLabel = titleLabel;
    self.titlePageControl = pageControl;
    self.navigationItem.titleView = titleView;
    
    [self setupContentViewControllers];
    
    [self.pageViewController setViewControllers:@[self.contentViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
}

- (void)setupContentViewControllers
{
    int index = 0;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:self.maxPoll];
    
//    EBPersonalityViewController *personalityViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalityViewController"];
//    personalityViewController.pageIndex = 0;
//    [viewControllers addObject:personalityViewController];
    
    for (index = 0; index < self.maxPoll; index += 1) {
        EBPollContentViewController *pollContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PollContentViewController"];
        pollContentViewController.pageIndex = index;
//        pollContentViewController.pageNumberLabel.text = [NSString stringWithFormat:@"Page: %d", index];
        [viewControllers addObject:pollContentViewController];
    }
    self.contentViewControllers = [viewControllers copy];
    self.titlePageControl.numberOfPages = self.contentViewControllers.count;
    self.titlePageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EBPollContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    return self.contentViewControllers[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((EBPollContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound || index + 1 >= self.maxPoll) {
        return nil;
    }
    return self.contentViewControllers[index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.maxPoll;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.titlePageControl.currentPage = [pageViewController.viewControllers[0] pageIndex];

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
