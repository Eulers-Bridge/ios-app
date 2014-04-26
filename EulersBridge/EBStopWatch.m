//
//  EBStopWatch.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBStopWatch.h"

@interface EBStopWatch ()

@property (strong, nonatomic) NSTimer *timer;
@property float timeInterval;
@property double time;

@end

@implementation EBStopWatch

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.time = 0;
        self.timeInterval = 1.0;
    }
    return self;
}

- (instancetype)initWithTimeInterval:(float)timeInterval
{
    self = [super init];
    if (self) {
        self.time = 0;
        self.timeInterval = timeInterval;
    }
    return self;
}

- (void)start
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
}

- (void)clear
{
    self.time = 0;
}

- (double)duration
{
    return self.time;
}

- (void)tick
{
    self.time += self.timeInterval;
    NSLog(@"%f", self.time);
}

@end
