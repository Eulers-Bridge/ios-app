//
//  EBCandidateTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 11/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBCandidateTableViewCell.h"

@implementation EBCandidateTableViewCell

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
- (IBAction)showDetail:(UIButton *)sender
{
//    [self.delegate candidateShowDetailWithCell:self];
    
}

- (void)revealButtonPressed
{
    [self.showDetailButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
