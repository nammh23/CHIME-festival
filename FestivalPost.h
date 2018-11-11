//
//  Festival Post.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/18/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface FestivalPost : NSObject
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *postText;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *date;
@end
