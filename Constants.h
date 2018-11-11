//
//  Constants.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/14/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString *const UserpostFieldsname;
extern NSString *const UserpostFieldstext;
extern NSString *const UserpostphotoURL;
extern NSString *const UserpostLat;
extern NSString *const UserpostLong;
extern NSString *const UserpostUserId;
extern NSString *const UserpostUserEmail;
extern NSString *const UserpostTime;
extern NSString *const UserpostFB;
extern NSString *const UserpostTW;

extern NSString *const UserId;
extern NSString *const Username;
extern NSString *const UserNickname;
extern NSString *const UserBio;
extern NSString *const UserMail;
extern NSString *const UserPhone;
extern NSString *const UserGender;
extern NSString *const UserAvatar;

+(NSString*)getPostPhotoDirectory;
/// Get Document directory of the app
+(NSString *)getDocumentDirectory;
+(NSString*) calculateDate:(NSString*) start;
@end
