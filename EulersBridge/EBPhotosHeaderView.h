//
//  EBPhotosHeaderView.h
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPhotosHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet EBLabelMedium *titleLabel;
@property (weak, nonatomic) IBOutlet EBLabelMedium *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
