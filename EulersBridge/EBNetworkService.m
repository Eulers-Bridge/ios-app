//
//  EBNetworkService.m
//  EulersBridge
//
//  Created by Alan Gao on 11/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBNetworkService.h"
#import "EBUserService.h"
#import "AFNetworking.h"
#import "MyConstants.h"
#import "EBUser.h"
#import "EBHelper.h"

@implementation EBNetworkService

#pragma mark User Services

- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password givenName:(NSString *)givenName familyName:(NSString *)familyName institutionId:(NSString *)institutionId
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    NSDictionary *parameters = @{@"email": email,
                                 @"givenName": givenName,
                                 @"familyName": familyName,
                                 @"gender": @"",
                                 @"nationality": @"",
                                 @"yearOfBirth": @"",
                                 @"password": password,
                                 @"institutionId": institutionId};
    [manager POST:@"http://eulersbridge.com:8080/dbInterface/api/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        EBUser *user = [self createAndSaveUser:res userId:nil password:password institutionId:res[@"institutionId"]];
        
        [self.userDelegate signupFinishedWithSuccess:YES withUser:user failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userDelegate signupFinishedWithSuccess:NO withUser:nil failureReason:error];
        
    }];
    
}

- (void)resendVerificationEmailForUser:(EBUser *)user
{
}

- (void)addPersonalityForUser:(EBUser *)user withParameters:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"http://eulersbridge.com:8080/dbInterface/api/user/%@/personality", TESTING_USERNAME];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.userDelegate addPersonalityForUserFinishedWithSuccess:YES withUser:user failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userDelegate addPersonalityForUserFinishedWithSuccess:NO withUser:nil failureReason:error];
        
    }];
    
    
}

- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"%@/login", TESTING_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
//        NSLog(@"JSON: %@", responseObject);
        EBUser *user = [self createAndSaveUser:res[@"user"] userId:res[@"userId"] password:password institutionId: res[@"user"][@"institutionId"]];
        [self.userDelegate loginFinishedWithSuccess:YES withUser:user failureReason:nil errorString:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        if ([[operation responseString] isEqualToString:LOGIN_ERROR_USER_UNVERIFIED]) {
            
            // Create the user object.
            EBUser *user = [[EBUser alloc] initWithEmail:email givenName:@"" password:password accountVerified:@"0" institutionId:@"" userId:@""];
            
            // Save the user in the system.
            EBUserService *userService = [[EBUserService alloc] init];
            [userService saveUser:user];
            
        }
        [self.userDelegate loginFinishedWithSuccess:NO withUser:nil failureReason:error errorString:[operation responseString]];
    }];

}

- (void)getUserWithUserEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.userDelegate getUserWithUserEmailFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userDelegate getUserWithUserEmailFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getGroupsWithUserEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/support/", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.userDelegate getGroupsWithUserEmailFinishedWithSuccess:YES withGroups:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userDelegate getGroupsWithUserEmailFinishedWithSuccess:NO withGroups:nil failureReason:error];
    }];

}

- (void)getNotificationWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/notifications/%@/", TESTING_URL, @"42"];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.userDelegate getNotificationsWithUserIdFinishedWithSuccess:YES withNotifications:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userDelegate getNotificationsWithUserIdFinishedWithSuccess:NO withNotifications:nil failureReason:error];
    }];
}

#pragma mark Friend Services

- (void)findFriendWithContactDetail:(NSString *)contactDetail originalContact:(NSDictionary *)contact
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, contactDetail];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.friendDelegate findFriendFinishedWithSuccess:YES withContact:contact failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate findFriendFinishedWithSuccess:NO withContact:nil failureReason:error];
    }];
}

- (void)getFriendsWithUserEmail:(NSString *)userEmail
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contacts/%@/", TESTING_URL, userEmail];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:YES withContacts:responseObject[@"foundObjects"] failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:NO withContacts:nil failureReason:error];
    }];
}

- (void)getFriendRequestSent
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/contactRequests/", TESTING_URL, [EBHelper getUserId]];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.friendDelegate getFriendRequestSentFinishedWithSuccess:YES withRequests:responseObject[@"foundObjects"] failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate getFriendRequestSentFinishedWithSuccess:NO withRequests:nil failureReason:error];
    }];
}

- (void)getFriendRequestReceived
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contactRequests/%@/", TESTING_URL, [EBHelper getUserId]];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.friendDelegate getFriendRequestReceivedFinishedWithSuccess:YES withRequests:responseObject[@"foundObjects"] failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate getFriendRequestReceivedFinishedWithSuccess:NO withRequests:nil failureReason:error];
    }];
}

- (void)addFriendWithEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/contact/%@/", TESTING_URL, [EBHelper getUserId], email];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.friendDelegate addFriendWithEmailFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate addFriendWithEmailFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)acceptFriendRequestWithRequestId:(NSString *)requestId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, requestId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.friendDelegate acceptFriendRequestFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate acceptFriendRequestFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)rejectFriendRequestWithRequestId:(NSString *)requestId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, requestId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.friendDelegate rejectFriendRequestFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.friendDelegate rejectFriendRequestFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (AFHTTPRequestOperationManager *)getHTTPRequestManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    return manager;
}

#pragma mark User Action Services

- (void)voteWithPollId:(NSString *)pollId answerIndex:(NSUInteger)answerIndex
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    double date = [[NSDate date] timeIntervalSince1970] / 1000;
    NSString *dateString = [NSString stringWithFormat:@"%.0f", date];

    NSDictionary *parameters = @{@"answerIndex": [NSString stringWithFormat:@"%lu", (unsigned long)answerIndex],
                                 @"timeStamp": dateString,
                                 @"answererId": [NSString stringWithFormat:@"%d", 8807],
                                 @"pollId": pollId};
    
    NSString *urlString = [NSString stringWithFormat:@"%@/poll/%@/answer", TESTING_URL, pollId];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.userActionDelegate votePollFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userActionDelegate votePollFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];

}

- (void)postPollCommentWithPollId:(NSString *)pollId comment:(NSString *)comment
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    double date = [[NSDate date] timeIntervalSince1970] / 1000;
    NSString *dateString = [NSString stringWithFormat:@"%.0f", date];
    
    NSDictionary *parameters = @{@"userName": @"iOS Test",
                                 @"timestamp": dateString,
                                 @"userEmail": [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"],
                                 @"targetId": pollId,
                                 @"content": comment};
    
    NSString *urlString = [NSString stringWithFormat:@"%@/comment", TESTING_URL];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.userActionDelegate postPollCommentFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userActionDelegate postPollCommentFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];

}

- (void)likeContentWithLike:(BOOL)like contentType:(EBContentViewType)contentType contentId:(NSString *)contentId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    NSString *contentTypeString;
    if (contentType == EBContentViewTypeNews) {
        contentTypeString = @"newsArticle";
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/",
                           TESTING_URL,
                           contentTypeString,
                           contentId,
                           like ? @"likedBy" : @"unlikedBy",
                           [EBUserService retriveUserEmail]];
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.userActionDelegate likeContentFinishedWithSuccess:YES withInfo:res failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.userActionDelegate likeContentFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];

}



#pragma mark Content Services

- (void)getNewsWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/newsArticles/%@?pageSize=100", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getNewsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getNewsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getNewsFeedIdWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/institution/%@/newsFeed", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getNewsFeedIdFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getNewsFeedIdFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getEventsWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/events/%@?pageSize=100", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getEventsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getEventsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getPhotoAlbumsWithNewsFeedId:(NSString *)newsFeedId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photoAlbums/%@?pageSize=100", TESTING_URL, newsFeedId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPhotoAlbumsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPhotoAlbumsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getPhotosWithAlbumId:(NSString *)albumId;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photos/%@?pageSize=100", TESTING_URL, albumId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPhotosFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPhotosFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getUserPhotosWithUserEmail:(NSString *)email;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/photos/%@?pageSize=100", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPhotosFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPhotosFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getElectionsInfoWithInstitutionId:(NSString *)institutionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/elections/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getElectionsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getElectionsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}


- (void)getElectionInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/election/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getElectionInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getElectionInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getPositionsInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/positions/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPositionsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPositionsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getCandidatesInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/candidates/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getCandidatesInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getCandidatesInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];

}

- (void)getTicketsInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/tickets/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getTicketsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getTicketsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
    
}

- (void)getPollsWithInstitutionId:(NSString *)institutionId

{
    NSString *urlString = [NSString stringWithFormat:@"%@/polls/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPollsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPollsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getPollResultsWithPollId:(NSString *)pollId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/poll/%@/results", TESTING_URL, pollId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPollResultsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPollResultsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getPollCommentsWithPollId:(NSString *)pollId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/comments/%@", TESTING_URL, pollId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getPollCommentsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getPollCommentsFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getCompleteBadgesWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/badges/complete/%@?pageSize=100", TESTING_URL, userId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getCompleteBadgesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getCompleteBadgesFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getRemainingBadgesWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/badges/remaining/%@?pageSize=100", TESTING_URL, userId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getRemainingBadgesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getRemainingBadgesFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getTasks
{
    NSString *urlString = [NSString stringWithFormat:@"%@/tasks?pageSize=100", TESTING_URL];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getTasksFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getTasksFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getNewsLikesWithArticleId:(NSString *)articleId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/newsArticle/%@/likes", TESTING_URL, articleId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.contentDelegate getNewsLikesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getNewsLikesFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getGeneralInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/general-info", TESTING_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *info = (NSDictionary *)responseObject;
        [self.contentDelegate getGeneralInfoFinishedWithSuccess:YES withInfo:info failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentDelegate getGeneralInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
    }];
}

- (void)getContentWithUrlString:(NSString *)urlString
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager GET:urlString parameters:nil success:success failure:failure];
    
}

- (EBUser *)createAndSaveUser:(NSDictionary *)resUser userId:(NSString *)userId password:(NSString *)password institutionId:(NSString *)institutionId
{
    // Create the user object.
    EBUser *user = [[EBUser alloc] initWithEmail:resUser[@"email"] givenName:resUser[@"givenName"] password:password accountVerified:resUser[@"accountVerified"] institutionId:institutionId userId:userId];
    
    // Save the user in the system.
    EBUserService *userService = [[EBUserService alloc] init];
    [userService saveUser:user];
    
    return user;

}


@end
