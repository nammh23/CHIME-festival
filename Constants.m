//
//  Constants.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/14/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const UserpostFieldsname = @"name";
NSString *const UserpostFieldstext = @"text";
NSString *const UserpostphotoURL = @"photoURL";
NSString *const UserpostLat = @"lat";
NSString *const UserpostLong = @"long";
NSString *const UserpostUserId = @"userid";
NSString *const UserpostUserEmail = @"email";
NSString *const UserpostTime = @"time";
NSString *const UserpostFB = @"facebook";
NSString *const UserpostTW = @"twitter";

NSString *const UserId = @"userID";
NSString *const Username = @"name";
NSString *const UserNickname = @"nickname";
NSString *const UserBio = @"bio";
NSString *const UserMail = @"mail";
NSString *const UserPhone = @"phone";
NSString *const UserGender = @"gender";
NSString *const UserAvatar = @"avatar";

+(NSString *)getDocumentDirectory {
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        return [paths firstObject];
    }
}

NSString* const DIRECTORY_POST_PHOTO = @"images/postphoto";
+(NSString*)getPostPhotoDirectory {
    @synchronized(self) {
        NSString *path = [[Constants getDocumentDirectory] stringByAppendingPathComponent:DIRECTORY_POST_PHOTO];
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
        return path;
    }
}

+(NSString*) calculateDate:(NSString*) start{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    NSString* result;
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* end = [NSString stringWithFormat:@"%@", [f stringFromDate:[NSDate date]]];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    if([components year] > 0){
        result = [NSString stringWithFormat:@"%ld year ago",(long)[components year]];
    }else if([components month] > 0){
        result = [NSString stringWithFormat:@"%ld month ago",(long)[components month]];
    }else if([components day]>0){
        result = [NSString stringWithFormat:@"%ld days ago",(long)[components day]];
    }else if([components hour]>0){
        result = [NSString stringWithFormat:@"%ld hours ago",(long)[components hour]];
    }else if([components minute]>0){
        result = [NSString stringWithFormat:@"%ld minutes ago",(long)[components minute]];
    }else if([components second] > 0){
        result = [NSString stringWithFormat:@"a few seconds ago"];
    }else{
        result = [NSString stringWithFormat:@"Just a moment ago"];
    }
    return result;
}

@end
