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

@protocol EBFriendServiceDelegate <NSObject>

- (void)findFriendFinishedWithSuccess:(BOOL)success withContact:(NSDictionary *)contact failureReason:(NSError *)error;

@end


@protocol EBContentServiceDelegate <NSObject>
@optional

- (void)getGeneralInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getNewsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getEventsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPhotoAlbumsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getElectionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPositionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getCandidatesInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getTicketsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;

- (void)getPollsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPollResultsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
@end

@protocol EBUserActionServiceDelegate <NSObject>
@optional

- (void)votePollFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
@end

@interface EBNetworkService : NSObject

@property (assign, nonatomic) id<EBSignupServiceDelegate> signupDelegate;
@property (assign, nonatomic) id<EBContentServiceDelegate> contentDelegate;
@property (assign, nonatomic) id<EBUserActionServiceDelegate> userActionDelegate;
@property (assign, nonatomic) id<EBFriendServiceDelegate> friendDelegate;

- (void)getGeneralInfo;

// TODO: Signup and login service
- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password givenName:(NSString *)givenName familyName:(NSString *)familyName institutionId:(NSString *)institutionId;

- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password;
- (void)resendVerificationEmailForUser:(EBUser *)user;

// Friend services
- (void)findFriendWithContactDetail:(NSString *)contactDetail originalContact:(NSDictionary *)contact;

// Content services
- (void)getNewsWithInstitutionId:(NSString *)institutionId;
- (void)getEventsWithInstitutionId:(NSString *)institutionId;
- (void)getPhotoAlbumsWithInstitutionId:(NSString *)institutionId;
- (void)getPhotosWithAlbumId:(NSString *)albumId;
- (void)getElectionInfoWithElectionId:(NSString *)electionId;
- (void)getPositionsInfoWithElectionId:(NSString *)electionId;
- (void)getCandidatesInfoWithElectionId:(NSString *)electionId;
- (void)getTicketsInfoWithElectionId:(NSString *)electionId;

- (void)getPollsWithInstitutionId:(NSString *)institutionId;
- (void)getPollResultsWithPollId:(NSString *)pollId;

// User action service
- (void)voteWithPollId:(NSString *)pollId answerIndex:(NSUInteger)answerIndex;

@end
