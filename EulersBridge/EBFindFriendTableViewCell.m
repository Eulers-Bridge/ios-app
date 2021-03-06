//
//  EBFindFriendTableViewCell.m
//  EulersBridge
//
//  Created by Alan Gao on 1/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFindFriendTableViewCell.h"

@implementation EBFindFriendTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteFriend:(UIButton *)sender
{
    [self.delegate inviteFriendWithContact:self.contact];
}

@end
