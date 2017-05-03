//
//  EBFriendTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 12/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBFriendTableViewCell.h"
#import "MyConstants.h"

@implementation EBFriendTableViewCell

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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionButtonPressed:(EBButtonRoundedHeavy *)sender
{
    [self.delegate actionButtonTapped:self.contact];
}

- (IBAction)accept:(UIButton *)sender
{
    sender.enabled = NO;
    [self.delegate acceptFriendWithRequestId:self.requestId];
}

- (IBAction)reject:(UIButton *)sender
{
    sender.enabled = NO;
    [self.delegate rejectFriendWithRequestId:self.requestId];
}

- (IBAction)showProfile:(UIButton *)sender {
    [self.delegate actionButtonTapped:self.contact];
}


-(void)prepareForReuse
{
    self.profileImageView.image = nil;
    self.requestId = nil;
    self.contact = nil;
    self.nameLabel.text = @"";
}

@end
