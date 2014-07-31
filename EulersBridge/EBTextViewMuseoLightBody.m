//
//  EBTextViewLight.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTextViewMuseoLightBody.h"
#import "MyConstants.h"

@implementation EBTextViewMuseoLightBody

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
        self.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:self.font.pointSize];
        self.textColor = ISEGORIA_TEXT_BODY_GREY;
        self.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return self;
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
