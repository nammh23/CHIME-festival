//
//  FestivalGetPost.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/20/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalGetPost.h"
#import "Constants.h"
@import Firebase;

@implementation FestivalGetPost
+(void)getAllPost{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[ref child:@"userpost"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        [[ref child:@"user"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *userSnapshot){
            for ( FIRDataSnapshot *child in snapshot.children) {
                NSString* key = child.key;
                NSDictionary *dict = child.value; //or craft an object instead of dict
                NSArray* arrayPost = dict.allValues;
                    //get user profile picture from database (Change here to improve performance
                for(NSMutableDictionary* value in arrayPost){
                    for(FIRDataSnapshot *userChild in userSnapshot.children){
                        if([key isEqualToString:userChild.key]){
                            [value setObject:key forKey:UserId];
                            [value setObject:userChild.value[UserAvatar] forKey:UserAvatar];
                            [value setObject:userChild.value[Username] forKey:Username];
                        }
                    }
                    [listPost addObject:value];
                }
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]; //sort by date key, descending
            NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
            [listPost sortUsingDescriptors: arrayOfDescriptors];
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"allPost", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allPost" object:nil userInfo:userInfo];
        }];
    }];
}

+(void)getCurrentUserPost:(NSString*) currentUser{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[[ref child:@"userpost"] child:currentUser] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        [[[ref child:@"user"] child:currentUser] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *userSnapshot){
            for ( FIRDataSnapshot *child in snapshot.children) {
                NSMutableDictionary *dict = [child.value mutableCopy]; //or craft an object instead of dict
                [dict setObject:currentUser forKey:UserId];
                for(FIRDataSnapshot *userChild in userSnapshot.children){
                    if([userChild.key isEqualToString:UserAvatar]){
                        [dict setObject:userChild.value forKey:UserAvatar];
                    }else if([userChild.key isEqualToString:Username]){
                        [dict setObject:userChild.value forKey:Username];
                    }
                }
                [listPost addObject:dict];
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]; //sort by date key, descending
            NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
            [listPost sortUsingDescriptors: arrayOfDescriptors];
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"allCurrentUserPost", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allCurrentUserPost" object:nil userInfo:userInfo];

        }];
    }];
}


+(void)getOtherUserPost:(NSString*) currentUser{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[ref child:@"userpost"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        [[ref child:@"user"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *userSnapshot){
        for ( FIRDataSnapshot *child in snapshot.children) {
            NSString* key = child.key;
            NSDictionary *dict = child.value; //or craft an object instead of dict
            //NSString *userID = [FIRAuth auth].currentUser.uid;
            if([currentUser isEqualToString:key] == NO){
                NSArray* arrayPost = dict.allValues;
                //get user profile picture from database (Change here to improve performance
                for(NSMutableDictionary* value in arrayPost){
                    for(FIRDataSnapshot *userChild in userSnapshot.children){
                        if([key isEqualToString:userChild.key]){
                            [value setObject:key forKey:UserId];
                            [value setObject:userChild.value[UserAvatar] forKey:UserAvatar];
                            [value setObject:userChild.value[Username] forKey:Username];
                        }
                    }
                    [listPost addObject:value];
                }
            }
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]; //sort by date key, descending
        NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [listPost sortUsingDescriptors: arrayOfDescriptors];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"allOtherUserPost", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allOtherUserPost" object:nil userInfo:userInfo];
        }];
    }];
}

+(void)getLastUserPost{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[ref child:@"userpost"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        [[ref child:@"user"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *userSnapshot){
            for ( FIRDataSnapshot *child in snapshot.children) {
                NSString* key = child.key;
                NSDictionary *dict = child.value;
                NSArray* allValue = dict.allValues;
                NSMutableArray<NSDictionary *>* arrayPost = [[NSMutableArray alloc] init];
                for(NSDictionary* aValue in allValue){
                    [arrayPost addObject:aValue];
                }
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
                NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
                [arrayPost sortUsingDescriptors: arrayOfDescriptors];
                //get user profile picture from database (Change here to improve performance
                if(arrayPost.count > 0){
                    NSMutableDictionary *value = [[arrayPost objectAtIndex:0] mutableCopy];
                    for(FIRDataSnapshot *userChild in userSnapshot.children){
                        if([key isEqualToString:userChild.key]){
                            [value setObject:userChild.key forKey:UserId];
                            [value setObject:userChild.value[UserAvatar] forKey:UserAvatar];
                            [value setObject:userChild.value[Username] forKey:Username];
                        }
                        [listPost addObject:value];
                    }
                }
            }
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"allLastUserPost", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allLastUserPost" object:nil userInfo:userInfo];
        }];
    }];
}
@end
