//
//  EBPersonalityTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 4/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBPersonalitySelectionDelegate <NSObject>

-(void)personalitySelectedWithAdjectiveIndex:(long)adjectiveIndex rateIndex:(int)rateIndex;

@end

@interface EBPersonalityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EBLabelMedium *titleLabel;

@property (weak, nonatomic) IBOutlet EBLabelMedium *label1;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label2;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label3;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label4;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label5;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label6;
@property (weak, nonatomic) IBOutlet EBLabelMedium *label7;

@property (strong, nonatomic) EBLabelMedium *selectedLabel;
@property (strong, nonatomic) NSArray *labelArray;
@property long index;

@property (weak, nonatomic) id<EBPersonalitySelectionDelegate> selectionDelegate;

-(void)setSelectionWithIndex:(int)index;

@end
