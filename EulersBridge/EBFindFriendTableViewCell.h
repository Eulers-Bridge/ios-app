//
//  EBFindFriendTableViewCell.h
//  EulersBridge
//
//  Created by Alan Gao on 1/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EBFindFriendCellDelegate <NSObject>

- (void)inviteFriendWithContact:(NSDictionary *)contact;

@end


@interface EBFindFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *contact;
@property (nonatomic, assign) id<EBFindFriendCellDelegate> delegate;

@end