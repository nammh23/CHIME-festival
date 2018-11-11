//
//  FestivalAttractionAnnotationView.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FestivalAttractionAnnotationView : MKAnnotationView
-(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point;
- (id)initWithCustomAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier image:(NSString*)imageURL;
@end
