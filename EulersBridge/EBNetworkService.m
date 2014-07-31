//
//  EBNetworkService.m
//  EulersBridge
//
//  Created by Alan Gao on 11/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBNetworkService.h"
#import "AFNetworking.h"

@implementation EBNetworkService

- (void)signupWithEmailAddress:(NSString *)email password:(NSString *)password name:(NSString *)name institutionId:(NSString *)institutionId
{
    [self.signupDelegate signupFinishedWithSuccess:YES withUser:nil failureReason:nil];

    return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    NSDictionary *parameters = @{@"email": @"test@test.com",
                                 @"firstName": @"gao",
                                 @"lastName": @"",
                                 @"gender": @"Male",
                                 @"nationality": @"Chinese",
                                 @"yearOfBirth": @"1988",
                                 @"personality": @"none",
                                 @"password": @"abc",
                                 @"institutionId": @"27"};
    [manager POST:@"http://eulersbridge.com:8080/dbInterface/api/signUp" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    [manager GET:@"http://www.eulersbridge.com:8080/dbInterface/api/user/gao@eulersbridge.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://10.0.0.23:8080/api/displayParams" parameters:@{@"abc":@"abc"} error:nil];
//    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    request = [mutableRequest copy];
//    
//    [[manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }] start];
    
    }

- (void)resendVerificationEmailForUser:(EBUser *)user
{
    
}


@end
