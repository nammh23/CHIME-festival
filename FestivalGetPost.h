//
//  FestivalGetPost.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/20/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalGetPost : NSObject
+(void)getAllPost;
+(void)getCurrentUserPost:(NSString*) currentUser;
+(void)getOtherUserPost:(NSString*) currentUser;
+(void)getLastUserPost;
@end
