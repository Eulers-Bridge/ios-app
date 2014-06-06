//
//  EBPollViewController.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPollViewController.h"
#import "EBPollContentViewController.h"

@interface EBPollViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *contentViewControllers;
@property int maxPoll;

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
    self.maxPoll = 5;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PollPageViewController"];
    self.pageViewController.dataSource = self;
    
    [self setupContentViewControllers];
    
    [self.pageViewController setViewControllers:@[self.contentViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)setupContentViewControllers
{
    int index = 0;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:self.maxPoll];
    for (index = 0; index < self.maxPoll; index += 1) {
        EBPollContentViewController *pollContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PollContentViewController"];
        pollContentViewController.pageIndex = index;
//        pollContentViewController.pageNumberLabel.text = [NSString stringWithFormat:@"Page: %d", index];
        [viewControllers addObject:pollContentViewController];
    }
    self.contentViewControllers = [viewControllers copy];
    
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
