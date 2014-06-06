//
//  EBElectionPositionDetailViewController.m
//  Isegoria
//
//  Created by Alan Gao on 7/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBElectionPositionDetailViewController.h"

@interface EBElectionPositionDetailViewController ()

@end

@implementation EBElectionPositionDetailViewController

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
    self.titleLabel.text = self.data[@"title"];
    self.descriptionTextView.text = self.data[@"description"];
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
