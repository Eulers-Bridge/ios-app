//
//  EBProfileDescriptionViewController.h
//  Isegoria
//
//  Created by Alan Gao on 14/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBContentDetail.h"

@interface EBProfileDescriptionViewController : UIViewController <EBContentDetail>

- (void)setupData:(NSDictionary *)data;

@end
