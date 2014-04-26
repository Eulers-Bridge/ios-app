//
//  EBStopWatch.h
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBStopWatch : NSObject



- (instancetype)initWithTimeInterval:(float)timeInterval;

- (void)start;

- (void)stop;

- (void)clear;

- (double)duration;

@end
