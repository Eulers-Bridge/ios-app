//
//  EBFeedCollectionViewCell.m
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MyConstants.h"

@implementation EBFeedCollectionViewCell


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)setup
{
    // Setup the frame according to content priority
//    self.frame = CGRectMake(self.frame.origin.x,
//                            self.frame.origin.y,
//                            [self.data[@"priority"] intValue] == 1 ? 307.0 : 150.0,
//                            self.frame.size.height);

    // Setup the mask.
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.imageView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor], nil];
    gradient.locations = @[@(0.0), @(1.0)];
    self.imageView.layer.mask = gradient;
    
    // Define Shadow object
//    NSShadow *shadow = [[NSShadow alloc] init];
//    [shadow setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.65]];
//    [shadow setShadowBlurRadius:1.5];
//    [shadow setShadowOffset:CGSizeMake(0, 0.5)];
    
    // The font
    UIFont *fontTitle = [UIFont fontWithName:@"MuseoSansRounded-300" size:[self.data[@"priority"] intValue] == 1 ? FONT_SIZE_CELL_TITLE_LARGE : FONT_SIZE_CELL_TITLE_SMALL];
    UIFont *fontDate = [UIFont fontWithName:@"MuseoSansRounded-300" size:[self.data[@"priority"] intValue] == 1 ? FONT_SIZE_CELL_DATE_LARGE : FONT_SIZE_CELL_DATE_SMALL];
    // The color
//    UIColor *color = [UIColor whiteColor];
//    NSDictionary *attributes = @{NSFontAttributeName: font,
//                                 NSShadowAttributeName: shadow,
//                                 NSForegroundColorAttributeName: color};
    if ([self.data[@"priority"] intValue] == 1) {
        CGRect frame = self.titleLabel.frame;
        frame.size.width = 295;
        self.titleLabel.frame = frame;
        CGRect dateframe = self.dateLabel.frame;
        dateframe.size.width = 295;
        self.dateLabel.frame = dateframe;
    }

    self.titleLabel.font = fontTitle;
    self.dateLabel.font = fontDate;
    self.titleLabel.text = self.data[@"title"];
    self.dateLabel.text = self.data[@"date"];
    
    // Setup the image
//    self.imageView.frame = self.bounds;

    self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
//    [self.imageView setImageWithURL:[NSURL URLWithString:self.data[@"imageUrl"]]];
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.titleLabel.text = nil;
    self.dateLabel.text = nil;
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
