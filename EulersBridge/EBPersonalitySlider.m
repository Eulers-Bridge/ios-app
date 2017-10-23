//
//  EBPersonalitySlider.m
//  Isegoria
//
//  Created by Alan Gao on 12/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPersonalitySlider.h"

@implementation EBPersonalitySlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 285, 10);
}


-(CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 285, 10);
}

-(CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, 285, 10);
}

//-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    return CGRectMake(0, 0, 24, 24);
//}

-(UIImage *)maximumTrackImageForState:(UIControlState)state
{
    return [UIImage imageNamed:@"sliderTrackWide"];
}

-(UIImage *)minimumTrackImageForState:(UIControlState)state
{
    return [[UIImage imageNamed:@"sliderTrackWide"] resizableImageWithCapInsets:UIEdgeInsetsZero];
}

-(UIImage *)thumbImageForState:(UIControlState)state
{
    return [UIImage imageNamed:@"sliderThumb"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
