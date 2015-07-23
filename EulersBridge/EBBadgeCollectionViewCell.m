//
//  EBBadgeCollectionViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 30/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBBadgeCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EBBadgeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setup
{
    self.service = [[EBNetworkService alloc] init];
    self.service.contentDelegate = self;
    [self.service getPhotosWithAlbumId:self.info[@"badgeId"]];
    
    self.badgeDescriptionLabel.text = self.info[@"description"];
    self.badgeNameLabel.text = self.info[@"name"];
}

- (void)getPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [self.badgeImageView setImageWithURL:[NSURL URLWithString:[info[@"photos"] firstObject][@"url"]]];
    } else {
        
    }
}

- (void)prepareForReuse
{
    self.service.contentDelegate = nil;
    self.badgeImageView.image = nil;
    self.badgeDescriptionLabel.text = @"";
    self.badgeNameLabel.text = @"";
}

- (void)dealloc
{
    self.service.contentDelegate = nil;
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
