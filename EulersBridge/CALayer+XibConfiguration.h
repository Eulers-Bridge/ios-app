//
//  CALayer+XibConfiguration.h
//  Isegoria
//
//  Created by Alan Gao on 28/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end
