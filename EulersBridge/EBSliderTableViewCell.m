//
//  EBSliderTableViewCell.m
//  Isegoria
//
//  Created by Alan Gao on 14/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSliderTableViewCell.h"

@implementation EBSliderTableViewCell

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
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderUpdate:) forControlEvents:UIControlEventValueChanged];
    self.degreeLabel.text = self.degreeTitles[3];
}

- (void)sliderUpdate:(UISlider *)slider
{
    float interval = slider.maximumValue / 6;
    float n = slider.value / interval;
    int section = (int)n;
    if (n - section > 0.5) {
        section += 1;
    }
    slider.value = section * interval;
    self.degreeLabel.text = self.degreeTitles[section];
    [self.selectionDelegate personalitySelectedWithAdjectiveIndex:self.index rateIndex:section];
}

-(void)setSelectionWithIndex:(int)index
{
    self.slider.value = (float)index * self.slider.maximumValue / 6;
    self.degreeLabel.text = self.degreeTitles[index];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
