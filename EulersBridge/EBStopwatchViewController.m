//
//  EBStopwatchViewController.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBStopwatchViewController.h"
#import "EBStopWatchInt.h"

@interface EBStopwatchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic, strong) EBStopWatchInt *stopwatch;
@end

@implementation EBStopwatchViewController

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
    self.stopwatch = [[EBStopWatchInt alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender {
    [self.stopwatch start];
}

- (IBAction)stop:(id)sender {
    [self.stopwatch stop];
    self.time.text = [NSString stringWithFormat:@"%d", [self.stopwatch duration]];
}

- (IBAction)clear:(id)sender {
    [self.stopwatch clear];
    self.time.text = @"0";
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
