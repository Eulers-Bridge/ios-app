//
//  EBNetworkService.m
//  EulersBridge
//
//  Created by Alan Gao on 11/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBNetworkService.h"

@implementation EBNetworkService

- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password name:(NSString *)name institutionId:(NSString *)institutionId
{
    [self.signupDelegate signupFinishedWithSuccess:YES withUser:nil failureReason:nil];
}

- (void)resendVerificationEmailForUser:(EBUser *)user
{
    
}


@end
