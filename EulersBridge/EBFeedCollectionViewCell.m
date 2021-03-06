//
//  EBFeedCollectionViewCell.m
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFeedCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

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
    if ([self.data[@"hasImage"] isEqualToString:@"true"]) {

        if (self.data[@"imageUrl"]) {
            NSURL *url = [NSURL URLWithString:self.data[@"imageUrl"]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                self.image = image;
                self.imageView.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"%@", error);
            }];
        } else {
            self.imageView.image = [UIImage imageNamed:self.data[@"imageName"]];
        }

    }

    
    if ([self.data[@"hasImage"] isEqualToString:@"false"] || self.feedCellType == EBFeedCellTypeSmall) {
        self.titleLabel.textColor = ISEGORIA_DARK_GREY;
        self.dateLabel.textColor = ISEGORIA_LIGHT_GREY;
        self.backgroundColor = ISEGORIA_ULTRA_LIGHT_GREY;
        self.layer.borderColor = [ISEGORIA_BORDER_GREY CGColor];
        self.layer.borderWidth = 1.0;
    } else {
        self.backgroundColor = ISEGORIA_CELL_MASK_GREY;
        // Setup the mask.
        self.titleLabel.textColor = [UIColor whiteColor];
        self.dateLabel.textColor = [UIColor whiteColor];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.35] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.35] CGColor], nil];
        gradient.locations = @[@(0.0), @(1.0)];
        self.imageView.layer.mask = gradient;
    }

    self.titleLabel.text = self.data[@"title"];
    self.dateLabel.text = self.data[@"date"];
    
    
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
