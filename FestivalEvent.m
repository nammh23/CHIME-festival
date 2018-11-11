//
//  FestivalEvent.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/22/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalEvent.h"
@import Firebase;
@implementation FestivalEvent
+(void)getAllEvent{
    FIRDatabaseReference *ref;
    FIRDatabaseHandle refHandle;
    NSMutableArray<NSDictionary *> *listPost = [[NSMutableArray alloc] init];
    ref = [[FIRDatabase database] reference];
    // Listen for new messages in the Firebase database
    refHandle = [[ref child:@"festival"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        [listPost removeAllObjects];
        for ( FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value; //or craft an object instead of dict
            [listPost addObject:dict];
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]; //sort by date key, descending
        NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [listPost sortUsingDescriptors: arrayOfDescriptors];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:listPost, @"allEvent", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allEvent" object:nil userInfo:userInfo];
    }];
}
@end
