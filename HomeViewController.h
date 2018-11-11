//
//  HomeViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/21/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
@interface HomeViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocationManager *objLocationManager;
    double latitude_UserLocation, longitude_UserLocation;
}
-(IBAction)setMap:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
