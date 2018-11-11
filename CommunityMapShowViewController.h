//
//  CommunityMapShowViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/30/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
@interface CommunityMapShowViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtnClicked;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSMutableArray<NSDictionary *> *listPost;
@end
