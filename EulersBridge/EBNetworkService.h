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
- (void)signupFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;
- (void)loginFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error errorString:(NSString *)errorString;
- (void)resendEmailFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;

@end

@protocol EBContentServiceDelegate <NSObject>
@optional

- (void)getGeneralInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getNewsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getEventsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;

@end

@interface EBNetworkService : NSObject

@property (assign, nonatomic) id<EBSignupServiceDelegate> signupDelegate;
@property (assign, nonatomic) id<EBContentServiceDelegate> contentDelegate;

- (void)getGeneralInfo;

// TODO: Signup and login service
- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password name:(NSString *)name institutionId:(NSString *)institutionId;

- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password;

- (void)resendVerificationEmailForUser:(EBUser *)user;
- (void)getNewsWithInstitutionId:(NSString *)institutionId;
- (void)getEventsWithInstitutionId:(NSString *)institutionId;
// TODO: Content service

// TODO: User action service

@end
