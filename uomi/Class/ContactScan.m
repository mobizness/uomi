//
//  ContactScan.m
//  uomi
//
//  Created by scs on 10/29/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ContactScan.h"
#import <Contacts/Contacts.h>

@implementation ContactScan
- (void) contactScan
{
    appController.arrPhoneContacts = [[NSMutableArray alloc]init];
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
                    [self getAllContact];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            [self getAllContact];
        }
    }
}

- (void) getAllContact
{
    if([CNContactStore class])
    {
        //iOS 9 or later
        NSError* contactError;
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
            [self parseContactWithContact:contact];
        }];
    }
}

- (void)parseContactWithContact :(CNContact* )contact
{
    NSString * firstName =  contact.givenName;
    NSString * lastName =  contact.familyName;
    NSArray * arrphone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSArray * arremail = [contact.emailAddresses valueForKey:@"value"];
    if (arrphone.count == 0) {
        return;
    }
    
    NSString *email = @"";
    if (arremail.count > 0) {
        email = [arremail objectAtIndex:0];
    }
    
    NSMutableDictionary *dicContact = [[NSMutableDictionary alloc]init];
    [dicContact setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"user_name"];
    [dicContact setObject:arrphone forKey:@"phone"];
    [dicContact setObject:email forKey:@"user_email"];
    [dicContact setObject:@"0" forKey:@"paid"];
    [dicContact setObject:@"0" forKey:@"received"];
    [dicContact setObject:[NSString stringWithFormat:@"%d",[appController.arrPhoneContacts count]] forKey:@"user_id"];
    [dicContact setObject:@"" forKey:@"user_image"];
    
    [appController.arrPhoneContacts addObject:dicContact];
    NSArray * addrArr = [self parseAddressWithContact:contact];
}

- (NSMutableArray *)parseAddressWithContact: (CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}
@end
