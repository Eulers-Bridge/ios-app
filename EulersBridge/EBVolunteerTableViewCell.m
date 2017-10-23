//
//  EBVolunteerTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 21/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBVolunteerTableViewCell.h"
#import "MyConstants.h"
#import "EBHelper.h"

@implementation EBVolunteerTableViewCell

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
    self.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:FONT_SIZE_VOLUNTEER_TITLE];
    self.positionsLeftLabel.font = [UIFont fontWithName:@"MuseoSansRounded-500" size:FONT_SIZE_VOLUNTEER_POSITION];
    self.positionsLeftLabel.textColor = [EBHelper greenColor];
    self.descriptionLabel.font = [UIFont fontWithName:@"MuseoSansRounded-300" size:FONT_SIZE_VOLUNTEER_DESCRIPTION];
    
    self.applyButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:FONT_SIZE_BUTTON];
    self.applyButton.titleLabel.textColor = [EBHelper greenColor];
    self.applyButton.layer.borderColor = [EBHelper greenColor].CGColor;
}

- (IBAction)apply:(UIButton *)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Send to Organizer" message:@"I would like to volunteer for the postion." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
