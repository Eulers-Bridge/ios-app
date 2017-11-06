//
//  EBUserService.m
//  Isegoria
//
//  Created by Alan Gao on 19/01/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import "EBUserService.h"

@implementation EBUserService


- (void)saveUser:(EBUser *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user.email forKey:@"userEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:user.institutionId forKey:@"institutionId"];
    [[NSUserDefaults standardUserDefaults] setBool:user.hasPersonality forKey:@"hasPersonality"];
    [[NSUserDefaults standardUserDefaults] setBool:user.profilePhotoURL forKey:@"profilePhotoURL"];
    [[NSUserDefaults standardUserDefaults] setBool:user.hasPPSEQuestions forKey:@"hasPPSEQuestions"];
}

+ (NSString *)retriveUserEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
}

+ (BOOL)hasPPSEQuestions
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hasPPSEQuestions"];
}

+ (void)setHasPPSEQuestions:(BOOL)hasPPSEQuestions
{
    [[NSUserDefaults standardUserDefaults] setBool:hasPPSEQuestions forKey:@"hasPPSEQuestions"];
}


@end
