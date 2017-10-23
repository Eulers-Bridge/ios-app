//
//  EBTextViewHelvetica.h
//  Isegoria
//
//  Created by Alan Gao on 27/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBTextBodyLayoutManagerDelegate.h"

@interface EBTextViewHelvetica : UITextView

@property (strong, nonatomic) EBTextBodyLayoutManagerDelegate *textDelegate;

@end
