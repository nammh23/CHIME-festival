//
//  FestivalSchedule.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/8/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FestivalAttractionAnnotation.h"
@interface FestivalSchedule : NSObject
@property (nonatomic) NSInteger scheduleID;
@property (strong, nonatomic) NSString* scheduleName;
@property (strong, nonatomic) NSString* scheduleDate;
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSString* scheduleDetail;
@property (strong, nonatomic) NSString* ticketLink;
@property (strong, nonatomic) NSString* place;

@end
