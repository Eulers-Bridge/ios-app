//
//  EBHelper.m
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBHelper.h"


@implementation EBHelper

+ (NSTimeInterval)timeIntervalWithHours:(double)hours minutes:(double)minutes seconds:(double)seconds
{
    return hours * 60 * 60 + minutes * 60 + seconds;
}

+ (NSArray *)contactsWithAddressBookRef:(ABAddressBookRef)addressBookRef
{
    NSMutableArray *contacts = [NSMutableArray array];
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    for (id record in allContacts) {
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        NSString *name = (__bridge NSString *)ABRecordCopyCompositeName(thisContact);
        
        // Get the emails.
        NSMutableArray *emails = [NSMutableArray array];
        ABMultiValueRef emailsRef = ABRecordCopyValue(thisContact, kABPersonEmailProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(emailsRef); i++) {
            NSString* emailAddress = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(emailsRef, i);
            [emails addObject:emailAddress];
        }
        
        // Get the phone numbers.
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        ABMultiValueRef phonesRef = ABRecordCopyValue(thisContact, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phonesRef); i++) {
            NSString* phoneNumber = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phonesRef, i);
            [phoneNumbers addObject:phoneNumber];
        }
        
        NSDictionary *person = @{PERSON_NAME_PROPERTY   : name,
                                 PERSON_EMAILS_PROPERTY : [emails copy],
                                 PERSON_PHONES_PROPERTY : [phoneNumbers copy]};
        
        
        [contacts addObject:person];
    }

    
    return [contacts copy];
}

+ (UIColor *)greenColor
{
    return [UIColor colorWithRed:96.0/255.0 green:195.0/255.0 blue:83.0/255.0 alpha:1.0];
}
@end
