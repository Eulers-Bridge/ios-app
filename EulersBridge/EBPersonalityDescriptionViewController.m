//
//  EBPersonalityDescriptionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 25/05/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBPersonalityDescriptionViewController.h"
#import "EBSlidersViewController.h"

@interface EBPersonalityDescriptionViewController ()

@end

@implementation EBPersonalityDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPersonalityQuestions"]) {
        EBSlidersViewController *personalityTable = (EBSlidersViewController *)[segue destinationViewController];
        personalityTable.user = self.user;
    }
}


@end
