//
//  EBEfficacySlider.m
//  Isegoria
//
//  Created by Alan Gao on 20/9/17.
//  Copyright © 2017 Eulers Bridge. All rights reserved.
//

#import "EBEfficacySlider.h"

@implementation EBEfficacySlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImage *)maximumTrackImageForState:(UIControlState)state
{
    return [UIImage imageNamed:@"sliderEfficacy"];
}

-(UIImage *)minimumTrackImageForState:(UIControlState)state
{
    return [[UIImage imageNamed:@"sliderEfficacy"] resizableImageWithCapInsets:UIEdgeInsetsZero];
}

@end
