//
//  EBNetworkService.h
//  EulersBridge
//
//  Created by Alan Gao on 11/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBUser.h"

@protocol EBSignupServiceDelegate <NSObject>
@optional
- (void)signupFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason;
- (void)resendEmailFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason;
- (void)getNewsWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason;

@end

@interface EBNetworkService : NSObject

@property (assign, nonatomic) id<EBSignupServiceDelegate> signupDelegate;

// TODO: Signup and login service
- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password name:(NSString *)name institutionId:(NSString *)institutionId;
- (void)resendVerificationEmailForUser:(EBUser *)user;
- (void)getNewsWithInstitutionId:(NSString *)institutionId;
// TODO: Content service

// TODO: User action service

@end
