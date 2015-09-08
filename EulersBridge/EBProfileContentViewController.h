//
//  EBProfileContentViewController.h
//  Isegoria
//
//  Created by Alan Gao on 3/09/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBContentDetail.h"


@interface EBProfileContentViewController : UIViewController <EBContentDetail>

- (void)setupData:(NSDictionary *)data;

@end
