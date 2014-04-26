//
//  EBHelper.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBHelper.h"

@implementation EBHelper

+ (NSTimeInterval)timeIntervalWithHours:(double)hours minutes:(double)minutes seconds:(double)seconds
{
    return hours * 60 * 60 + minutes * 60 + seconds;
}

@end
