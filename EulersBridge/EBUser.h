//
//  EBUser.h
//  Isegoria
//
//  Created by Alan Gao on 7/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBBadge.h"
#import "EBTask.h"

@interface EBUser : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *givenName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *emailVerified;
@property (strong, nonatomic) NSString *institutionId;
@property (strong, nonatomic) NSString *profilePhotoURL;
@property (strong, nonatomic) NSArray *badgesEarned;
@property (strong, nonatomic) NSArray *tasksCompleted;
@property BOOL hasPersonality;

-(EBUser *)initWithEmail:(NSString *)email givenName:(NSString *)givenName password:(NSString *)password accountVerified:(NSString *)accountVerified institutionId:(NSString *)institutionId userId:(NSString *)userId hasPersonality:(BOOL)hasPersonaltiy profilePhotoURL:(NSString *)profilePhotoURL;

@end
