//
//  EBCandidateTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 11/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBCandidateCellDelegate.h"

@interface EBCandidateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EBLabelMedium *nameLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *candidateImageView;
@property (weak, nonatomic) IBOutlet UIButton *showDetailButton;
@property (weak, nonatomic) IBOutlet EBLabelMedium *codeLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property NSUInteger index;

- (void)revealButtonPressed;

//@property (assign, nonatomic) id<EBCandidateCellDelegate> delegate;

@end
