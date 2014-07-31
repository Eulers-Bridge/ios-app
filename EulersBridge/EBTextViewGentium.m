//
//  EBTextViewMuseo.m
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTextViewGentium.h"
#import "MyConstants.h"

@implementation EBTextViewGentium

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
        self.font = [UIFont fontWithName:@"GentiumPlus" size:self.font.pointSize];
        self.textColor = ISEGORIA_TEXT_BODY_GREY;
//        self.layoutManager.delegate = self;
        self.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return self;
}

//-(CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
//{
//    return -20.0;
//}

//- (CGRect)caretRectForPosition:(UITextPosition *)position
//{
//    CGRect originalRect = [super caretRectForPosition:position];
//    // Resize the rect. For example make it 75% by height:
//    originalRect.size.height *= 0.1;
//    return originalRect;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
