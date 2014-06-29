//
//  EBTicketCollectionViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 27/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBTicketCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EBLabelLight *titleLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property int ticketId;

@end
