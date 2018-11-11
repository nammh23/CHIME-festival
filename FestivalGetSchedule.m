//
//  FestivalGetSchedule.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/28/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalGetSchedule.h"
@import Firebase;
@implementation FestivalGetSchedule
+(void)getAllSchedule:(NSString*) festival{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableDictionary* listSchedule = [[NSMutableDictionary alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[ref child:festival] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listSchedule removeAllObjects];
        for ( FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value; //or craft an object instead of dict
            [listSchedule setValue:dict forKey:child.key];
        }

        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listSchedule, @"allSchedule", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allSchedule" object:nil userInfo:userInfo];
    }];
}

@end
