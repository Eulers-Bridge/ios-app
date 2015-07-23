//
//  EBTaskTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 1/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBTaskTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EBTaskTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setup
{
    self.service = [[EBNetworkService alloc] init];
    self.service.contentDelegate = self;
    [self.service getPhotosWithAlbumId:self.info[@"taskId"]];
    
    self.xpValueLabel.text = [[self.info[@"xpValue"] stringValue] stringByAppendingString:@" XP"];
    self.titleLabel.text = self.info[@"action"];
}

- (void)getPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error
{
    if (success) {
        [self.taskImageView setImageWithURL:[NSURL URLWithString:[info[@"photos"] lastObject][@"url"]]];
    } else {
        
    }
}

- (void)prepareForReuse
{
    self.service.contentDelegate = nil;
    self.taskImageView.image = nil;
    self.xpValueLabel.text = @"";
    self.titleLabel.text = @"";
}

- (void)dealloc
{
    self.service.contentDelegate = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
