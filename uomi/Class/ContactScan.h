//
//  ContactScan.h
//  uomi
//
//  Created by scs on 10/29/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface ContactScan : NSObject
- (void)contactScan;
- (void)getAllContact;
- (void)parseContactWithContact :(CNContact* )contact;
- (NSMutableArray *)parseAddressWithContact: (CNContact *)contact;
@end
