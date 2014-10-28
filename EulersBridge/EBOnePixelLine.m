//
//  EBOnePixelLine.m
//  Isegoria
//
//  Created by Alan Gao on 25/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBOnePixelLine.h"

@implementation EBOnePixelLine

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
                                CGRectMake(0, 0, self.frame.size.width, sortaPixel)];
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
