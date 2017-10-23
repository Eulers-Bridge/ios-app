//
//  EBBlurImageView.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBBlurImageView.h"
#import "UIImage+ImageEffects.h"
#import "MyConstants.h"

@implementation EBBlurImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    [self setImage:image withBlurRadius:DEFAULT_BLUR_RADIUS];
}

- (void)setImage:(UIImage *)image withBlurRadius:(float)blurRadius
{
//    UIColor *tintColor = [UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:0.5];
    UIColor *tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    UIImage *finishedImage = [image applyBlurWithRadius:blurRadius tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    [super setImage:finishedImage];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
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
