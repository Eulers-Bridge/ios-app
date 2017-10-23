//
//  EBCircleProgressBar.h
//  Isegoria
//
//  Created by Alan Gao on 24/03/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBCircleProgressBar : UIView

@property (strong, nonatomic) UIColor *mainColor;
@property float progress;

- (void)animate;

@end
