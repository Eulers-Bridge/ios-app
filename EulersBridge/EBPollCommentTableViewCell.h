//
//  EBPollCommentTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 29/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPollCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EBLabelMedium *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@end
