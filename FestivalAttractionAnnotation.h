//
//  FestivalAttractionAnnotation.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, AttractionType) {
    AttractionDefault = 0,
    AttractionBuilding,
    AttractionOcean,
    AttractionChurch,
    AttractionAssociation,
    AttractionCustom
};

@interface FestivalAttractionAnnotation : NSObject<MKAnnotation>
@property (nonatomic) NSString* aID;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *profilePic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) AttractionType type;
@end
