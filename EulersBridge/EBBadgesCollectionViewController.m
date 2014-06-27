//
//  EBBadgesCollectionViewController.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBBadgesCollectionViewController.h"

@interface EBBadgesCollectionViewController ()

@end

@implementation EBBadgesCollectionViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"badgeCellMedium" forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"badge%ld%@",(long)indexPath.item,
                           self.badgesViewType == EBBadgesViewTypeSmall ? @"m" : @"l"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imageView];
    return cell;
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
