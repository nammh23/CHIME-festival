//
//  FestivalGetProfile.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/29/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalGetProfile : NSObject
+(void)getCurrentUserProfile:(NSString*) currentUser;
+(void)getOtherUserProfile:(NSString *)otherUser;
@end
