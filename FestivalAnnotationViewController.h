//
//  FestivalAnnotationViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/3/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface FestivalAnnotationViewController : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIImageView *postPicture;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (nonatomic) CLLocationCoordinate2D *coordinate;


@end
