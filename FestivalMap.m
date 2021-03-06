//
//  FestivalMap.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalMap.h"
#import "MapKit/MapKit.h"
@implementation FestivalMap

- (instancetype)initWithFilename:(NSString *)filename {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        _midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
        
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
        
        CGPoint overlayBottomRightPoint = CGPointFromString(properties[@"overlayBottomRightCoord"]);
        _overlayBottomRightCoordinate = CLLocationCoordinate2DMake(overlayBottomRightPoint.x, overlayBottomRightPoint.y);

        NSArray *boundaryPoints = properties[@"boundary"];
        
        _boundaryPointsCount = boundaryPoints.count;
        
        _boundary = malloc(sizeof(CLLocationCoordinate2D)*_boundaryPointsCount);
        
        for(int i = 0; i < _boundaryPointsCount; i++) {
            CGPoint p = CGPointFromString(boundaryPoints[i]);
            _boundary[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
    }
    
    return self;
}

- (MKMapRect)overlayBoundingMapRect {
    
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
    
    return MKMapRectMake(topLeft.x,
                         topLeft.y,
                         fabs(topLeft.x - topRight.x),
                         fabs(topLeft.y - bottomLeft.y));
}

@end

