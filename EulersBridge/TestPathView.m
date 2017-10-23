//
//  TestPathView.m
//  Isegoria
//
//  Created by Alan Gao on 1/04/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "TestPathView.h"

@implementation TestPathView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addCurveToPoint:CGPointMake(300, 300) controlPoint1:CGPointMake(400, 500) controlPoint2:CGPointMake(250, 200)];
    [path addLineToPoint:CGPointMake(200, 500)];
//    [path fill];
    [path stroke];
}

@end
