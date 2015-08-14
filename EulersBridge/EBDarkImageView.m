//
//  EBDarkImageView.m
//  Isegoria
//
//  Created by Alan Gao on 14/08/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBDarkImageView.h"

@implementation EBDarkImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setImage:(UIImage *)image
{
    UIColor *tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    UIImage *finishedImage = [image applyBlurWithRadius:0 tintColor:tintColor saturationDeltaFactor:0 maskImage:nil];
    [super setImage:finishedImage];
}

@end
