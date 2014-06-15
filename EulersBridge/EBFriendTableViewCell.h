//
//  EBFriendTableViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 12/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBFindFriendCellDelegate <NSObject>

- (void)inviteFriendWithContact:(NSDictionary *)contact;

@end

@interface EBFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet EBLabelMedium *nameLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *subtitleLabel;
@property (nonatomic, assign) id<EBFindFriendCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *contact;

@end
