//
//  EBElectionPositionDetailViewController.h
//  Isegoria
//
//  Created by Alan Gao on 7/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBElectionPositionDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet EBLabelHeavy *titleLabel;
@property (weak, nonatomic) IBOutlet EBTextViewMuseoLight *descriptionTextView;
@property (strong, nonatomic) NSDictionary *data;
@end
