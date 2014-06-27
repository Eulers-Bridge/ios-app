//
//  EBBlurImageView.m
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBBlurImageView.h"
#import "UIImage+ImageEffects.h"

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
    UIColor *tintColor = [UIColor colorWithRed:51.0/255.0 green:56.0/255.0 blue:69.0/255.0 alpha:0.5];
    UIImage *finishedImage = [image applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
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
