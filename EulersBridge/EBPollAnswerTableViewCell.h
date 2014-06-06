//
//  EBPollAnswerTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPollAnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet EBLabelMedium *answerTitleLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *answerSubtitleLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *resultNumberLabel;

@property (strong, nonatomic) NSDictionary *result;
@property (strong, nonatomic) NSDictionary *answer;
@property (strong, nonatomic) UIColor *baseColor;
@property BOOL voted;

- (void)showResult;
- (void)refreshData;

@end
