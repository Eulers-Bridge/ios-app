//
//  EBButton.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBButton.h"
#import "UIImage+ImageWithColor.h"

@implementation EBButton

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
        self.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.titleLabel.font.pointSize];
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.titleLabel.textColor = self.textColor ? self.textColor : self.mainColor;

    [self setTitleColor:self.titleLabel.textColor forState:UIControlStateNormal];
    
    UIColor *highlightedColor = self.highlightedColor ? self.highlightedColor : self.mainColor;
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateSelected];
    
    
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
