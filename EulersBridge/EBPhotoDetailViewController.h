//
//  EBPhotoDetailViewController.h
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBPhotoDetailViewController : UIViewController

@property (strong, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) UIImageView *leftPhotoImageView;
@property (strong, nonatomic) UIImageView *rightPhotoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *leftPhotoScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *centrePhotoScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *rightPhotoScrollView;


@property (weak, nonatomic) IBOutlet EBLabelLight *titleLabel;
@property (strong, nonatomic) NSArray *photoDataList;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *titleName;

@property (strong, nonatomic) NSDictionary *data;
@property NSUInteger index;
@property NSUInteger numberOfPhotos;

@end
