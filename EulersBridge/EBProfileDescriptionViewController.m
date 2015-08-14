//
//  EBProfileDescriptionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 14/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBProfileDescriptionViewController.h"
#import "EBHelper.h"
#import "EBTextViewHelvetica.h"

@interface EBProfileDescriptionViewController ()

@property (weak, nonatomic) IBOutlet EBTextViewHelvetica *textView;

@end

@implementation EBProfileDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupData:(NSDictionary *)data
{
    self.textView.text = data[@"policyStatement"];
//    CGFloat oldHeight = self.textView.frame.size.height;
//    [EBHelper resetTextView:self.textView];
//    CGFloat textViewExtraHeight = self.textView.frame.size.height - oldHeight;
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + textViewExtraHeight + TEXT_BODY_INSET * 2);
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
