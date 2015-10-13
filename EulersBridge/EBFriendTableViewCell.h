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
- (void)acceptFriendWithRequestId:(NSString *)requestId;
- (void)rejectFriendWithRequestId:(NSString *)requestId;

@end

@interface EBFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet EBLabelMedium *nameLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *requestActionView;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailButton;
@property (nonatomic, assign) id<EBFindFriendCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *contact;
@property (strong, nonatomic) NSString *requestId;

@end
