//
//  EBPollContentViewController.h
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPollContentViewController : UIViewController

@property int pageIndex;
@property (weak, nonatomic) IBOutlet EBLabelLight *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *answerTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) NSDictionary *info;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) NSArray *baseColors;


@end
