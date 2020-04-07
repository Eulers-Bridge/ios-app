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

- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password givenName:(NSString *)givenName familyName:(NSString *)familyName yearOfBirth:(NSString *)yearOfBirth gender:(NSString *)gender institutionId:(NSString *)institutionId profilePicURL:(NSString *)profilePicURL
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    NSDictionary *parameters = @{@"email": email,
                                 @"givenName": givenName,
                                 @"familyName": familyName,
                                 @"gender": gender,
                                 @"nationality": @"",
                                 @"yearOfBirth": yearOfBirth,
                                 @"password": password,
                                 @"institutionId": institutionId,
                                 @"profilePhoto": profilePicURL};
    NSString *urlString = [NSString stringWithFormat:@"%@/signUp", TESTING_URL];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
        EBUser *user = [self createAndSaveUser:res userId:nil password:password institutionId:res[@"institutionId"] hasPersonality:NO hasPPSEQuestions:NO profilePhotoURL:profilePicURL];
        if (self.userDelegate != nil) {
            [self.userDelegate signupFinishedWithSuccess:YES withUser:user failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate signupFinishedWithSuccess:NO withUser:nil failureReason:error];
        }
    }];
    
}

- (void)resendVerificationEmailForUser:(EBUser *)user
{
}

- (void)requestPasswordResetWithEmail:(NSString *)email
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", @"text/plain", nil];
    NSDictionary *parameters = [NSDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:@"%@/requestPwdReset/%@/", TESTING_URL, email];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userDelegate != nil) {
            [self.userDelegate requestPasswordResetWithEmailFinishedWithSuccess:YES failureReason:nil errorString:@""];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate requestPasswordResetWithEmailFinishedWithSuccess:NO failureReason:error errorString:error.localizedDescription];
        }
    }];

}

- (void)updateUserGender:(NSString *)gender
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    NSDictionary *parameters = @{@"gender": gender};
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@", TESTING_URL, TESTING_USERNAME];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userDelegate != nil) {
            [self.userDelegate updateUserGenderWithSuccess:YES failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate updateUserGenderWithSuccess:NO failureReason:error];
        }
        
    }];
}

- (void)updateProfilePicURL:(NSString *)profilePicURL
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    NSDictionary *parameters = @{@"profilePhoto": profilePicURL};
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@", TESTING_URL, TESTING_USERNAME];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userDelegate != nil) {
            [self.userDelegate updateProfilePicURLWithSuccess:YES failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate updateProfilePicURLWithSuccess:NO failureReason:error];
        }
        
    }];
}

- (void)addPersonalityForUser:(EBUser *)user withParameters:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/personality", TESTING_URL, TESTING_USERNAME];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userDelegate != nil) {
            [self.userDelegate addPersonalityForUserFinishedWithSuccess:YES withUser:user failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate addPersonalityForUserFinishedWithSuccess:NO withUser:nil failureReason:error];
        }
        
    }];
}

- (void)addEfficacyForUser:(EBUser *)user withParameters:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/PPSEQuestions", TESTING_URL, TESTING_USERNAME];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userDelegate != nil) {
            [self.userDelegate addEfficacyForUserFinishedWithSuccess:YES withUser:user failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate addEfficacyForUserFinishedWithSuccess:NO withUser:nil failureReason:error];
        }
        
    }];
}



- (void)loginWithEmailAddress:(NSString *)email password:(NSString *)password arn:(NSString *)arn deviceToken:(NSString *)deviceToken
{
    NSString *notificationString = @"";
    if (![deviceToken isEqualToString:@""]) {
        notificationString = [NSString stringWithFormat:@"?topicArn=%@&deviceToken=%@", SNSPlatformApplicationArn, deviceToken];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/login%@", TESTING_URL, notificationString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    // Debug timeout
//    [manager.requestSerializer setTimeoutInterval:1800];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
//        NSLog(@"JSON: %@", responseObject);
        BOOL hasPersonality = ([res[@"user"][@"hasPersonality"] isEqual: @(YES)]);
        BOOL hasPPSEQuestions = ([res[@"user"][@"hasPPSEQuestions"] isEqual: @(YES)]);
        EBUser *user = [self createAndSaveUser:res[@"user"] userId:res[@"userId"] password:password institutionId: res[@"user"][@"institutionId"] hasPersonality:hasPersonality hasPPSEQuestions:hasPPSEQuestions profilePhotoURL:res[@"user"][@"profilePhoto"]];
        if (self.userDelegate != nil) {
            [self.userDelegate loginFinishedWithSuccess:YES withUser:user failureReason:nil errorString:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        if ([[operation responseString] isEqualToString:LOGIN_ERROR_USER_UNVERIFIED]) {
            
            // Create the user object.
            EBUser *user = [[EBUser alloc] initWithEmail:email givenName:@"" password:password accountVerified:@"0" institutionId:@"" userId:@"" hasPersonality:NO hasPPSEQuestions:NO profilePhotoURL:@""];
            
            // Save the user in the system.
            EBUserService *userService = [[EBUserService alloc] init];
            [userService saveUser:user];
            
        }
        if (self.userDelegate != nil) {
            [self.userDelegate loginFinishedWithSuccess:NO withUser:nil failureReason:error errorString:[operation responseString]];
        }
    }];

}

- (void)getUserWithUserEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.userDelegate != nil) {
            [self.userDelegate getUserWithUserEmailFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate getUserWithUserEmailFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getGroupsWithUserEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/support/", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.userDelegate != nil) {
            [self.userDelegate getGroupsWithUserEmailFinishedWithSuccess:YES withGroups:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate getGroupsWithUserEmailFinishedWithSuccess:NO withGroups:nil failureReason:error];
        }
    }];

}

- (void)getNotificationWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/notifications/%@/", TESTING_URL, @"42"];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.userDelegate != nil) {
            [self.userDelegate getNotificationsWithUserIdFinishedWithSuccess:YES withNotifications:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userDelegate != nil) {
            [self.userDelegate getNotificationsWithUserIdFinishedWithSuccess:NO withNotifications:nil failureReason:error];
        }
    }];
}

#pragma mark Friend Services

- (void)findFriendWithContactDetail:(NSString *)contactDetail originalContact:(NSDictionary *)contact
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contact/%@/", TESTING_URL, contactDetail];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate findFriendFinishedWithSuccess:YES withContact:contact failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate findFriendFinishedWithSuccess:NO withContact:nil failureReason:error];
        }
    }];
}

- (void)findFriendWithName:(NSString *)name
{
    NSString *urlString = [NSString stringWithFormat:@"%@/searchUserProfile/%@/", TESTING_URL, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate findFriendWithNameFinishedWithSuccess:YES withContacts:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate findFriendWithNameFinishedWithSuccess:NO withContacts:nil failureReason:error];
        }
    }];
}

- (void)getFriendsWithUserEmail:(NSString *)userEmail
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contacts/%@/", TESTING_URL, userEmail];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:YES withContacts:responseObject[@"foundObjects"] failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:NO withContacts:nil failureReason:error];
        }
    }];
}

- (void)getMyFriends
{
    NSString *urlString = [NSString stringWithFormat:@"%@/contacts", TESTING_URL];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:YES withContacts:responseObject[@"foundObjects"] failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendsWithUserEmailFinishedWithSuccess:NO withContacts:nil failureReason:error];
        }
    }];
}

- (void)getFriendRequestSent
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/contactRequests/", TESTING_URL, [EBHelper getUserId]];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendRequestSentFinishedWithSuccess:YES withRequests:responseObject[@"foundObjects"] failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendRequestSentFinishedWithSuccess:NO withRequests:nil failureReason:error];
        }
    }];
}

- (void)getFriendRequestReceived
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/contactRequests/rec", TESTING_URL, [EBHelper getUserId]];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendRequestReceivedFinishedWithSuccess:YES withRequests:responseObject[@"foundObjects"] failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate getFriendRequestReceivedFinishedWithSuccess:NO withRequests:nil failureReason:error];
        }
    }];
}

- (void)addFriendWithEmail:(NSString *)email
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/contactRequest/%@/", TESTING_URL, [EBHelper getUserId], email];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate addFriendWithEmailFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate addFriendWithEmailFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)acceptFriendRequestWithRequestId:(NSString *)requestId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/contactRequest/%@/accept", TESTING_URL, requestId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate acceptFriendRequestFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate acceptFriendRequestFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)rejectFriendRequestWithRequestId:(NSString *)requestId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/contactRequest/%@/reject", TESTING_URL, requestId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate rejectFriendRequestFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate rejectFriendRequestFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)deleteFriendRequestWithRequestId:(NSString *)requestId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/contactRequest/%@", TESTING_URL, requestId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate deleteFriendRequestFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.friendDelegate != nil) {
            [self.friendDelegate deleteFriendRequestFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
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

- (void)addVoteReminder:(NSString *)electionId date:(NSDate *)date location:(NSString *)location
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    NSString *dateString = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970] * 1000];
    NSDictionary *parameters = @{@"userEmail": [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"],
                                     @"electionId": electionId,
                                     @"date": dateString,
                                     @"location": location};
    
    NSString *urlString = [NSString stringWithFormat:@"%@/user/%@/voteReminder", TESTING_URL, [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"]];
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id res) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)voteWithPollId:(NSString *)pollId answerId:(NSString *)answerId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
//    double date = [[NSDate date] timeIntervalSince1970] / 1000;
//    NSString *dateString = [NSString stringWithFormat:@"%.0f", date];

//    NSDictionary *parameters = @{@"answerIndex": [NSString stringWithFormat:@"%lu", (unsigned long)answerIndex],
//                                 @"timeStamp": dateString,
//                                 @"answererId": [NSString stringWithFormat:@"%@", [EBHelper getUserId]],
//                                 @"pollId": pollId};
    
    NSString *urlString = [NSString stringWithFormat:@"%@/poll/%@/vote/%@", TESTING_URL, pollId, answerId];
    [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
        if (self.userActionDelegate != nil) {
            [self.userActionDelegate votePollFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userActionDelegate != nil) {
            [self.userActionDelegate votePollFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
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
        if (self.userActionDelegate != nil) {
            [self.userActionDelegate postPollCommentFinishedWithSuccess:YES withInfo:res failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.userActionDelegate != nil) {
            [self.userActionDelegate postPollCommentFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
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
    if (contentType == EBContentViewTypePhoto) {
        contentTypeString = @"photo";
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/",
                           TESTING_URL,
                           contentTypeString,
                           contentId,
//                           like ? @"likedBy" : @"unlikedBy",
                            @"likedBy",
                           [EBUserService retriveUserEmail]];
    if (like) {
        [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate likeContentFinishedWithSuccess:YES withInfo:res failureReason:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate likeContentFinishedWithSuccess:NO withInfo:nil failureReason:error];
            }
        }];
    } else {
        [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate likeContentFinishedWithSuccess:YES withInfo:res failureReason:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate likeContentFinishedWithSuccess:NO withInfo:nil failureReason:error];
            }
        }];
    }
    

}

- (void)supportTicketWithSupport:(BOOL)support ticketId:(NSString *)ticketId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:TESTING_USERNAME password:TESTING_PASSWORD];
    manager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/ticket/%@/support/%@/", TESTING_URL, ticketId, [EBUserService retriveUserEmail]];
    if (support) {
        [manager PUT:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
             if (self.userActionDelegate != nil) {
                [self.userActionDelegate supportTicketFinishedWithSuccess:YES withInfo:res failureReason:nil];
             }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate supportTicketFinishedWithSuccess:NO withInfo:nil failureReason:error];
            }
        }];
    } else {
        [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id res) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate supportTicketFinishedWithSuccess:YES withInfo:res failureReason:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.userActionDelegate != nil) {
                [self.userActionDelegate supportTicketFinishedWithSuccess:NO withInfo:nil failureReason:error];
            }
        }];
    }
    
}



#pragma mark Content Services

- (void)getNewsWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/newsArticles/%@?pageSize=100", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getNewsFeedIdWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/institution/%@/newsFeed", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsFeedIdFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsFeedIdFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getEventsWithInstitutionId:(NSString *)institutionId
{
    
    institutionId = TESTING_INSTITUTION_ID;
    NSString *urlString = [NSString stringWithFormat:@"%@/events/%@?pageSize=100", TESTING_URL, TESTING_INSTITUTION_ID];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getEventsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getEventsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPhotoAlbumsWithNewsFeedId:(NSString *)newsFeedId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photoAlbums/%@?pageSize=100", TESTING_URL, newsFeedId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotoAlbumsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotoAlbumsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPhotosWithAlbumId:(NSString *)albumId;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photos/%@?pageSize=100", TESTING_URL, albumId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotosFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotosFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getUserPhotosWithUserEmail:(NSString *)email;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/user/photos/%@?pageSize=100", TESTING_URL, email];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotosFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotosFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getElectionsInfoWithInstitutionId:(NSString *)institutionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/elections/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getElectionsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getElectionsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}


- (void)getElectionInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/election/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getElectionInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getElectionInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPositionsInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/positions/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPositionsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPositionsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getCandidatesInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/candidates/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getCandidatesInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getCandidatesInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];

}

- (void)getTicketsInfoWithElectionId:(NSString *)electionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/tickets/%@", TESTING_URL, electionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTicketsInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTicketsInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
    
}

- (void)getVotingLocationInfoWithInstitutionId:(NSString *)institutionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/votingLocations/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getVotingLocationInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getVotingLocationInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPollsWithInstitutionId:(NSString *)institutionId

{
//    NSString *urlString = [NSString stringWithFormat:@"%@/polls/7449", TESTING_URL, institutionId];
    NSString *urlString = [NSString stringWithFormat:@"%@/polls/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPollResultsWithPollId:(NSString *)pollId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/poll/%@/results", TESTING_URL, pollId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollResultsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollResultsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPollCommentsWithPollId:(NSString *)pollId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/comments/%@", TESTING_URL, pollId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollCommentsFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPollCommentsFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getCompleteBadgesWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/badges/complete/%@?pageSize=100", TESTING_URL, userId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getCompleteBadgesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getCompleteBadgesFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getRemainingBadgesWithUserId:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/badges/remaining/%@?pageSize=100", TESTING_URL, userId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getRemainingBadgesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getRemainingBadgesFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getTasks
{
    NSString *urlString = [NSString stringWithFormat:@"%@/tasks?pageSize=100", TESTING_URL];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTasksFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTasksFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getNewsLikesWithArticleId:(NSString *)articleId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/newsArticle/%@/likes", TESTING_URL, articleId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsLikesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getNewsLikesFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getPhotoLikesWithPhotoId:(NSString *)photoId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/photo/%@/likes", TESTING_URL, photoId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotoLikesFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getPhotoLikesFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getSupportsWithTicketId:(NSString *)ticketId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/ticket/%@/supporters", TESTING_URL, ticketId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTicketSupportersFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getTicketSupportersFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getInstitutionInfoWithInstitutionId:(NSString *)institutionId
{
    NSString *urlString = [NSString stringWithFormat:@"%@/institution/%@", TESTING_URL, institutionId];
    
    [self getContentWithUrlString:urlString success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getInstitutionInfoFinishedWithSuccess:YES withInfo:responseObject failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getInstitutionInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}


- (void)getServerInfo
{
    NSString *urlString = @"https://www.isegoria.com.au/26af2fdb70869d7a57ebbd65afde108fd92a9367/institutions.json";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *servers = (NSArray *)responseObject;
        NSDictionary *info = (NSDictionary *)responseObject;
        if (self.contentDelegate != nil) {
            [self.contentDelegate getServerInfoFinishedWithSuccess:YES withInfo:info failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getServerInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
    }];
}

- (void)getGeneralInfo
{
    NSString *urlString = [NSString stringWithFormat:@"%@/general-info", TESTING_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json", @"application/json", @"application/xml", nil];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *info = (NSDictionary *)responseObject;
        if (self.contentDelegate != nil) {
            [self.contentDelegate getGeneralInfoFinishedWithSuccess:YES withInfo:info failureReason:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.contentDelegate != nil) {
            [self.contentDelegate getGeneralInfoFinishedWithSuccess:NO withInfo:nil failureReason:error];
        }
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

- (EBUser *)createAndSaveUser:(NSDictionary *)resUser userId:(NSString *)userId password:(NSString *)password institutionId:(NSString *)institutionId hasPersonality:(BOOL)hasPersonality hasPPSEQuestions:(BOOL)hasPPSEQuestions  profilePhotoURL:(NSString *)profilePhotoURL
{
    // Create the user object.
    EBUser *user = [[EBUser alloc] initWithEmail:resUser[@"email"] givenName:resUser[@"givenName"] password:password accountVerified:resUser[@"accountVerified"] institutionId:institutionId userId:userId hasPersonality:hasPersonality hasPPSEQuestions:hasPPSEQuestions profilePhotoURL:resUser[@"profilePhoto"]];
    
    // Save the user in the system.
    EBUserService *userService = [[EBUserService alloc] init];
    [userService saveUser:user];
    
    return user;

}


@end
