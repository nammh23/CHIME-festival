//
//  FestivalDirectionMapViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/13/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalDirectionMapViewController.h"

@interface FestivalDirectionMapViewController (){
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;

}

@end

@implementation FestivalDirectionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    // Make the destination
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:_desLocation addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    // Set the source and destination on the request
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        // So there wasn't an error - let's plot those routes
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = _cancelBtnClicked;
        self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Direction";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelBtnClicked:(id)sender {
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
    
}
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
