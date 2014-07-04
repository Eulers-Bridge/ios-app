//
//  EBPersonalityTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 4/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBPersonalityTableViewCell.h"
#import "MyConstants.h"

@implementation EBPersonalityTableViewCell

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
    self.labelArray = @[self.label1,
                        self.label2,
                        self.label3,
                        self.label4,
                        self.label5,
                        self.label6,
                        self.label7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    if (self.selectedLabel) {
        self.selectedLabel.backgroundColor = PERSONALITY_LABEL_GREY;
    }
}

- (IBAction)selectAction:(UIButton *)sender
{
    int rateIndex = [sender.titleLabel.text intValue];
    [self.selectionDelegate personalitySelectedWithAdjectiveIndex:self.index rateIndex:rateIndex];
    [self setSelectionWithIndex:rateIndex];
}

-(void)setSelectionWithIndex:(int)index
{
    if (self.selectedLabel) {
        self.selectedLabel.backgroundColor = PERSONALITY_LABEL_GREY;
    }
    if (index == 0) {
        return;
    }
    self.selectedLabel = self.labelArray[index - 1];
    self.selectedLabel.backgroundColor = ISEGORIA_COLOR_GREEN;
}

@end
