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
}

+ (NSString *)retriveUserEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
}


@end
