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

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *email;
@property BOOL emailVerified;
@property (strong, nonatomic) NSString *institutionId;
@property (strong, nonatomic) NSArray *badgesEarned;
@property (strong, nonatomic) NSArray *tasksCompleted;

@end
