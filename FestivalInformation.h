//
//  FestivalInformation.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/24/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalInformation : NSObject
@property (nonatomic) NSInteger festivalID;
@property (strong, nonatomic) NSString* festivalName;
@property (strong, nonatomic) NSString* festivalDate;
@property (strong, nonatomic) NSString* avatar;

@end
