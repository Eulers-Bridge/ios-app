//
//  EBHelper.h
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyConstants.h"
#import "EBAppDelegate.h"
@import AddressBook;

@interface EBHelper : NSObject


+ (NSTimeInterval)timeIntervalWithHours:(double)hours minutes:(double)minutes seconds:(double)seconds;

+ (NSArray *)contactsWithAddressBookRef:(ABAddressBookRef)addressBookRef;

+ (UIColor *)greenColor;

+ (EBAppDelegate *)getAppDelegate;

+ (CGSize)getScreenSize;

@end
