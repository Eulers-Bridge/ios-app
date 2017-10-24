//
//  EBNetworkService.h
//  EulersBridge
//
//  Created by Alan Gao on 11/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBUser.h"

@protocol EBUserServiceDelegate <NSObject>
@optional
- (void)signupFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;
- (void)loginFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error errorString:(NSString *)errorString;
- (void)resendEmailFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;
- (void)requestPasswordResetWithEmailFinishedWithSuccess:(BOOL)success failureReason:(NSError *)error errorString:(NSString *)errorString;
- (void)addPersonalityForUserFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;
- (void)addEfficacyForUserFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSError *)error;
- (void)getUserWithUserEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getGroupsWithUserEmailFinishedWithSuccess:(BOOL)success withGroups:(NSArray *)groups failureReason:(NSError *)error;
- (void)getNotificationsWithUserIdFinishedWithSuccess:(BOOL)success withNotifications:(NSArray *)notifications failureReason:(NSError *)error;
@end

@protocol EBFriendServiceDelegate <NSObject>
@optional
- (void)findFriendFinishedWithSuccess:(BOOL)success withContact:(NSDictionary *)contact failureReason:(NSError *)error;
- (void)findFriendWithNameFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error;
- (void)getFriendsWithUserEmailFinishedWithSuccess:(BOOL)success withContacts:(NSArray *)contacts failureReason:(NSError *)error;
- (void)getFriendRequestSentFinishedWithSuccess:(BOOL)success withRequests:(NSArray *)contacts failureReason:(NSError *)error;
- (void)getFriendRequestReceivedFinishedWithSuccess:(BOOL)success withRequests:(NSArray *)contacts failureReason:(NSError *)error;
- (void)addFriendWithEmailFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)acceptFriendRequestFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)rejectFriendRequestFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
@end


@protocol EBContentServiceDelegate <NSObject>
@optional

- (void)getGeneralInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getInstitutionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getNewsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getNewsFeedIdFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getEventsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPhotoAlbumsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getUserPhotosFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getElectionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getElectionInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPositionsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getCandidatesInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getTicketsInfoFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getNewsLikesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getTicketSupportersFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;

- (void)getPollsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPollResultsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getPollCommentsFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getCompleteBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getRemainingBadgesFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)getTasksFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;

@end

@protocol EBUserActionServiceDelegate <NSObject>
@optional

- (void)votePollFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)postPollCommentFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)likeContentFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
- (void)supportTicketFinishedWithSuccess:(BOOL)success withInfo:(NSDictionary *)info failureReason:(NSError *)error;
@end

@interface EBNetworkService : NSObject

@property (assign, nonatomic) id<EBUserServiceDelegate> userDelegate;
@property (assign, nonatomic) id<EBContentServiceDelegate> contentDelegate;
@property (assign, nonatomic) id<EBUserActionServiceDelegate> userActionDelegate;
@property (assign, nonatomic) id<EBFriendServiceDelegate> friendDelegate;

- (void)getGeneralInfo;

// Signup, login and user service
- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password givenName:(NSString *)givenName familyName:(NSString *)familyName institutionId:(NSString *)institutionId profilePicURL:(NSString *)profilePicURL;

- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password arn:(NSString *)arn deviceToken:(NSString *)deviceToken;
- (void)resendVerificationEmailForUser:(EBUser *)user;
- (void)requestPasswordResetWithEmail:(NSString *)email;
- (void)addPersonalityForUser:(EBUser *)user withParameters:(NSDictionary *)parameters;
- (void)addEfficacyForUser:(EBUser *)user withParameters:(NSDictionary *)parameters;
- (void)getUserWithUserEmail:(NSString *)email;
- (void)getGroupsWithUserEmail:(NSString *)email;
- (void)getNotificationWithUserId:(NSString *)userId;

// Friend services
- (void)findFriendWithContactDetail:(NSString *)contactDetail originalContact:(NSDictionary *)contact;
- (void)findFriendWithName:(NSString *)name;
- (void)getFriendsWithUserEmail:(NSString *)userEmail;
- (void)getMyFriends;
- (void)getFriendRequestSent;
- (void)getFriendRequestReceived;
- (void)addFriendWithEmail:(NSString *)email;
- (void)acceptFriendRequestWithRequestId:(NSString *)requestId;
- (void)rejectFriendRequestWithRequestId:(NSString *)requestId;


// Content services
- (void)getInstitutionInfoWithInstitutionId:(NSString *)institutionId;
- (void)getNewsWithInstitutionId:(NSString *)institutionId;
- (void)getNewsFeedIdWithInstitutionId:(NSString *)institutionId;
- (void)getEventsWithInstitutionId:(NSString *)institutionId;
- (void)getPhotoAlbumsWithNewsFeedId:(NSString *)newsFeedId;
- (void)getPhotosWithAlbumId:(NSString *)albumId;
- (void)getUserPhotosWithUserEmail:(NSString *)email;
- (void)getElectionsInfoWithInstitutionId:(NSString *)institutionId;
- (void)getElectionInfoWithElectionId:(NSString *)electionId;
- (void)getPositionsInfoWithElectionId:(NSString *)electionId;
- (void)getCandidatesInfoWithElectionId:(NSString *)electionId;
- (void)getTicketsInfoWithElectionId:(NSString *)electionId;
- (void)getNewsLikesWithArticleId:(NSString *)articleId;
- (void)getSupportsWithTicketId:(NSString *)ticketId;

- (void)getPollsWithInstitutionId:(NSString *)institutionId;
- (void)getPollResultsWithPollId:(NSString *)pollId;
- (void)getPollCommentsWithPollId:(NSString *)pollId;

- (void)getCompleteBadgesWithUserId:(NSString *)userId;
- (void)getRemainingBadgesWithUserId:(NSString *)userId;
- (void)getTasks;

// User action service
- (void)addVoteReminder;
- (void)voteWithPollId:(NSString *)pollId answerId:(NSString *)optionId;
- (void)postPollCommentWithPollId:(NSString *)pollId comment:(NSString *)comment;
- (void)likeContentWithLike:(BOOL)like contentType:(EBContentViewType)contentType contentId:(NSString *)contentId;
- (void)supportTicketWithSupport:(BOOL)support ticketId:(NSString *)ticketId;
@end
