//
//  EBTextViewHelvetica.m
//  Isegoria
//
//  Created by Alan Gao on 27/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBTextViewHelvetica.h"
#import "MyConstants.h"

@implementation EBTextViewHelvetica


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:FONT_SIZE_ARTICLE_BODY];
        self.textColor = ISEGORIA_DARK_GREY;
        self.textContainerInset = UIEdgeInsetsMake(TEXT_BODY_INSET, TEXT_BODY_INSET, TEXT_BODY_INSET, TEXT_BODY_INSET);
        self.textDelegate = [[EBTextBodyLayoutManagerDelegate alloc] init];
        self.layoutManager.delegate = self.textDelegate;

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont systemFontOfSize:FONT_SIZE_ARTICLE_BODY];
        self.textColor = ISEGORIA_DARK_GREY;
        self.textContainerInset = UIEdgeInsetsMake(TEXT_BODY_INSET, TEXT_BODY_INSET, TEXT_BODY_INSET, TEXT_BODY_INSET);
        self.textDelegate = [[EBTextBodyLayoutManagerDelegate alloc] init];
        self.layoutManager.delegate = self.textDelegate;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
