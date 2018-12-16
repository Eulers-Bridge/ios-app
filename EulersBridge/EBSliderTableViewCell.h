//
//  EBSliderTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 14/08/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBPersonalitySlider.h"

@protocol EBPersonalitySelectionDelegate <NSObject>

-(void)personalitySelectedWithAdjectiveIndex:(long)adjectiveIndex rateIndex:(int)rateIndex;

@end


@interface EBSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EBPersonalitySlider *slider;
@property (weak, nonatomic) IBOutlet EBLabelMedium *titleLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *degreeLabel;

@property int numChoice;
@property (strong, nonatomic) NSArray *degreeTitles;
@property long index;

@property (weak, nonatomic) id<EBPersonalitySelectionDelegate> selectionDelegate;

-(void)setSelectionWithIndex:(int)index;

@end
