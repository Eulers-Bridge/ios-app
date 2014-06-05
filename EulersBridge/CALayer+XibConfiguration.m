//
//  CALayer+XibConfiguration.m
//  Isegoria
//
//  Created by Alan Gao on 28/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
