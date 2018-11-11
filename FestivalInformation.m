//
//  FestivalInformation.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/24/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalInformation.h"

@implementation FestivalInformation
-(NSString*)description {
    return [NSString stringWithFormat:@"{FestivalID = %ld, name = %@, avatarURL = %@,}", (long)self.festivalID, self.festivalName, self.avatar];
}

@end
