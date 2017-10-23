//
//  EBUserService.h
//  Isegoria
//
//  Created by Alan Gao on 19/01/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBUser.h"

@interface EBUserService : NSObject


- (void)saveUser:(EBUser *)user;
+ (NSString *)retriveUserEmail;

@end
