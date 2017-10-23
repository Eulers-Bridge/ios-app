//
//  EBUser.m
//  Isegoria
//
//  Created by Alan Gao on 7/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBUser.h"

@implementation EBUser


-(EBUser *)initWithEmail:(NSString *)email givenName:(NSString *)givenName password:(NSString *)password accountVerified:(NSString *)accountVerified institutionId:(NSString *)institutionId userId:(NSString *)userId hasPersonality:(BOOL)hasPersonaltiy profilePhotoURL:(NSString *)profilePhotoURL
{
    self.email = email;
    self.givenName = givenName;
    self.password = password;
    self.userId = userId;
    self.hasPersonality = hasPersonaltiy;
    self.profilePhotoURL = profilePhotoURL;
//    self.emailVerified = accountVerified;
    NSInteger id = [institutionId integerValue];
    self.institutionId = [NSString stringWithFormat:@"%ld", (long)id];
    return self;
}

@end
