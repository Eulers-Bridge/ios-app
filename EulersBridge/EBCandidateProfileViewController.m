//
//  EBCandidateProfileViewController.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateProfileViewController.h"
#import "EBFriendProfileViewController.h"
#import "EBBlurImageView.h"

@interface EBCandidateProfileViewController ()
@property (weak, nonatomic) IBOutlet EBBlurImageView *backgroundPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet EBLabelLight *nameLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *institutionLabel;

@end

@implementation EBCandidateProfileViewController

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
    self.backgroundPhoto.image = [UIImage imageNamed:self.imageName];
    self.profilePhoto.image = [UIImage imageNamed:self.imageName];
    self.nameLabel.text = self.name;
    self.navigationItem.title = self.name;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    if ([segue.identifier isEqualToString:@"viewFullProfile"]) {
        EBFriendProfileViewController *dest = (EBFriendProfileViewController *)[segue destinationViewController];
        dest.name = self.name;
        dest.imageName = self.imageName;
    }
}


@end
