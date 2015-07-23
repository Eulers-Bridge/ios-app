//
//  EBTaskTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 1/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBNetworkService.h"

@interface EBTaskTableViewCell : UITableViewCell <EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet EBLabelMedium *titleLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *xpValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;

@property (strong, nonatomic) NSDictionary *info;

@property (strong, nonatomic) EBNetworkService *service;

- (void)setup;

@end
