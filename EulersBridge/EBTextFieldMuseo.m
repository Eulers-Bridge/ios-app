//
//  EBTextFieldMuseo.m
//  Isegoria
//
//  Created by Alan Gao on 8/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTextFieldMuseo.h"

@implementation EBTextFieldMuseo

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
        self.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:self.font.pointSize];
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
