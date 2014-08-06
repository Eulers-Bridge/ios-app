//
//  EBPhotoDetailViewController.h
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPhotoDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightPhotoImageView;

@property (weak, nonatomic) IBOutlet EBLabelLight *titleLabel;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *titleName;

@property (strong, nonatomic) NSDictionary *data;
@property NSUInteger index;

@end
