//
//  EBPersonalityViewController.m
//  Isegoria
//
//  Created by Alan Gao on 4/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPersonalityViewController.h"
#import "EBPersonalityTableViewCell.h"

@interface EBPersonalityViewController () <UITableViewDataSource, UITableViewDelegate, EBPersonalitySelectionDelegate>

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *selectionArray;
@property (weak, nonatomic) IBOutlet UIView *introductionView;

@end

@implementation EBPersonalityViewController

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
    self.titleArray = @[@"Extraverted, enthusiastic",
                        @"Critical, quarrelsome",
                        @"Dependable, self-disciplined",
                        @"Anxious, easily upset",
                        @"Open to new experiences, complex",
                        @"Reserved, quiet",
                        @"Sympathetic, warm",
                        @"Disorganized, careless",
                        @"Calm, emotionally stable",
                        @"Conventional, uncreative"];
    self.selectionArray = [NSMutableArray array];
    for (int i = 0; i < 10; i += 1) {
        [self.selectionArray addObject:@(0)];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBPersonalityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalityCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    [cell setSelectionWithIndex:[self.selectionArray[indexPath.row] intValue]];
    cell.selectionDelegate = self;
    cell.index = indexPath.row;
    return cell;
}

- (IBAction)revealQuestions:(id)sender
{
    self.introductionView.hidden = YES;
}

#pragma mark personality selection delegate
-(void)personalitySelectedWithAdjectiveIndex:(long)adjectiveIndex rateIndex:(int)rateIndex
{
    [self.selectionArray replaceObjectAtIndex:adjectiveIndex withObject:@(rateIndex)];
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
