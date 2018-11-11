//
//  FestivalGetProfile.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/29/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalGetProfile.h"
#import "Constants.h"
@import Firebase;

@implementation FestivalGetProfile
+(void)getCurrentUserProfile:(NSString *)currentUser{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[[ref child:@"user"] child:currentUser ] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        for ( FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = @{child.key:child.value}; //or craft an object instead of dict
            [listPost addObject:dict];
        }
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"UserProfile", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfile" object:nil userInfo:userInfo];
    }];
}

+(void)getOtherUserProfile:(NSString *)otherUser{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[[ref child:@"user"] child:otherUser ] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        for ( FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = @{child.key:child.value}; //or craft an object instead of dict
            [listPost addObject:dict];
        }
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"OtherProfile", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OtherProfile" object:nil userInfo:userInfo];
    }];
}

@end
