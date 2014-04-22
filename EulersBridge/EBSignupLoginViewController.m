//
//  EBSignupLoginViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 22/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSignupLoginViewController.h"

@interface EBSignupLoginViewController ()

@end

@implementation EBSignupLoginViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)doneClicked:(id)sender
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    // animation
//    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"] animated:YES completion:nil];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.navigationController.view.frame = CGRectOffset(self.navigationController.view.frame, 0.0, 300.0);
//    } completion:^(BOOL finished) {
//        
//        
//    }];

    
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
