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

@implementation EBNetworkService

- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password givenName:(NSString *)givenName familyName:(NSString *)familyName institutionId:(NSString *)institutionId
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    NSDictionary *parameters = @{@"email": email,
                                 @"givenName": givenName,
                                 @"familyName": familyName,
                                 @"gender": @"",
                                 @"nationality": @"",
                                 @"yearOfBirth": @"",
                                 @"password": password,
                                 @"institutionId": institutionId};
    [manager POST:@"http://eulersbridge.com:8080/dbInterface/api/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        EBUser *user = [self createAndSaveUser:res userId:nil];
        
        [self.signupDelegate signupFinishedWithSuccess:YES withUser:user failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.signupDelegate signupFinishedWithSuccess:NO withUser:nil failureReason:error];
        
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://eulersbridge.com:8080/dbInterface/api/user/greg.newitt@unimelb.edu.au/personality"];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        [self.signupDelegate addPersonalityForUserFinishedWithSuccess:YES withUser:user failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.signupDelegate addPersonalityForUserFinishedWithSuccess:NO withUser:nil failureReason:error];
        
    }];
    
    
}

- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"%@/login", TESTING_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
//        NSLog(@"JSON: %@", responseObject);
        EBUser *user = [self createAndSaveUser:res[@"user"] userId:res[@"userId"]];
        [self.signupDelegate loginFinishedWithSuccess:YES withUser:user failureReason:nil errorString:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        if ([[operation responseString] isEqualToString:LOGIN_ERROR_USER_UNVERIFIED]) {
            
            // Create the user object.
            EBUser *user = [[EBUser alloc] initWithEmail:email givenName:@"" password:password accountVerified:@"0" institutionId:@"" userId:@""];
            
            // Save the user in the system.
            EBUserService *userService = [[EBUserService alloc] init];
            [userService saveUser:user];
            
        }
        [self.signupDelegate loginFinishedWithSuccess:NO withUser:nil failureReason:error errorString:[operation responseString]];
    }];

}

- (void)getUserWithUserEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.signupDelegate getUserWithUserEmailFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.signupDelegate getUserWithUserEmailFinishedWithSuccess:NO withInfo:nil failureReason:error];
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




#pragma mark User Action Services

- (void)voteWithPollId:(NSString *)pollId answerIndex:(NSUInteger)answerIndex
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", nil];
    
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

- (void)getPhotoAlbumsWithInstitutionId:(NSString *)institutionId;
{
    institutionId = TESTING_PHOTO_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/photoAlbums/%@?pageSize=100", TESTING_URL, TESTING_PHOTO_INSTITUTION_ID];
    
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
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", nil];
    
    [manager GET:urlString parameters:nil success:success failure:failure];
    
}

- (EBUser *)createAndSaveUser:(NSDictionary *)res userId:(NSString *)userId
{
    // Create the user object.
    EBUser *user = [[EBUser alloc] initWithEmail:res[@"email"] givenName:res[@"givenName"] password:res[@"password"] accountVerified:res[@"accountVerified"] institutionId:res[@"institutionId"] userId:userId];
    
    // Save the user in the system.
    EBUserService *userService = [[EBUserService alloc] init];
    [userService saveUser:user];
    
    return user;

}


@end
