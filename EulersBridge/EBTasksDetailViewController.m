//
//  EBTasksDetailViewController.m
//  Isegoria
//
//  Created by Alan Gao on 3/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTasksDetailViewController.h"
#import "EBTasksTableViewController.h"

@interface EBTasksDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *progressViewFrame;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@end

@implementation EBTasksDetailViewController

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
    self.progressViewFrame.backgroundColor = [UIColor clearColor];
    self.progressViewFrame.layer.borderWidth = 1.0;
    self.progressViewFrame.layer.borderColor = [self.progressView.backgroundColor CGColor];
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
    if ([segue.identifier isEqualToString:@"TasksDetail"]) {
        EBTasksTableViewController *tasksViewController = (EBTasksTableViewController *)[segue destinationViewController];
        tasksViewController.tasksViewType = EBTasksViewTypeDetail;
    }
}

@end
