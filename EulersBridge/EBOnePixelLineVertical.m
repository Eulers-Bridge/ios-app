//
//  EBOnePixelLineVertical.m
//  Isegoria
//
//  Created by Alan Gao on 24/03/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBOnePixelLineVertical.h"

@implementation EBOnePixelLineVertical

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    // careful, contentScaleFactor does not work
    // in storyboard during initWithCoder:
    // float sortaPixel = 1.0/self.contentScaleFactor;
    // instead, use mainScreen scale which works perfectly:
    
}

- (void)setNeedsLayout
{
    float sortaPixel = 1.0/[UIScreen mainScreen].scale;
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:
                                CGRectMake(0, 0, sortaPixel, self.frame.size.height)];
    [topSeparatorView setBackgroundColor:self.backgroundColor];
    [self addSubview:topSeparatorView];
    self.backgroundColor = [UIColor clearColor];
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
