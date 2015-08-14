//
//  EBEventDetailTableViewController.h
//  Isegoria
//
//  Created by Alan Gao on 3/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBContentDetail.h"

@interface EBEventDetailTableViewController : UITableViewController <EBContentDetail>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *data;

- (void)setupData:(NSDictionary *)data;

@end
