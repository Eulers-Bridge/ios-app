//
//  EBButtonRounded.m
//  Isegoria
//
//  Created by Alan Gao on 25/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBButtonRounded.h"
#import "UIImage+ImageWithColor.h"

@implementation EBButtonRounded

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = self.bounds.size.height / 2;
        self.layer.borderWidth = 1.0;
        self.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.titleLabel.font.pointSize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = self.mainColor.CGColor;
    
    UIColor *textHighlightedColor = self.textHighlightedColor ? self.textHighlightedColor : [UIColor whiteColor];
    [self setTitleColor:textHighlightedColor forState:UIControlStateHighlighted];
    [self setTitleColor:textHighlightedColor forState:UIControlStateSelected];
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
