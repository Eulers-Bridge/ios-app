//
//  EBArticleViewController.h
//  Isegoria
//
//  Created by Alan Gao on 28/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBContentDetail.h"

@interface EBArticleViewController : UIViewController <EBContentDetail>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *data;


- (void)setupData:(NSDictionary *)data;
- (void)setupAuthorData:(NSDictionary *)data;

@end
