//
//  HomeViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/21/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "HomeViewController.h"
#import "FestivalInformation.h"
#import "FestivalMap.h"
#import "FestivalAttractionAnnotation.h"
#import "FestivalAttractionAnnotationView.h"
@import Firebase;
@import Photos;
@interface HomeViewController ()
@property (nonatomic, strong) FestivalMap *mapArea;
@property (nonatomic, strong) NSMutableArray *selectedOptions;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    objLocationManager = [[CLLocationManager alloc] init];
    if ([objLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [objLocationManager requestWhenInUseAuthorization];
    }
    [self configureDatabase];
    [self configureStorage];
    //[self loadUserLocation];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationController.navigationBar.topItem.title = @"Home";
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.selectedOptions = [NSMutableArray array];
    self.mapArea = [[FestivalMap alloc] initWithFilename:@"GMLSTN"];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    CLLocationDegrees latDelta = self.mapArea.overlayTopLeftCoordinate.latitude - self.mapArea.overlayBottomRightCoordinate.latitude;
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), 0.0);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapArea.midCoordinate, span);
    self.mapView.region = region;
    [self addAttractionPins];
    //[self addBoundary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureDatabase {
    _ref = [[FIRDatabase database] reference];
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}


- (void)addAttractionPins {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GMLSTNAttractions" ofType:@"plist"];
    NSArray *attractions = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *attraction in attractions) {
        FestivalAttractionAnnotation *annotation = [[FestivalAttractionAnnotation alloc] init];
        CGPoint point = CGPointFromString(attraction[@"location"]);
        annotation.aID = attraction[@"id"];
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title = attraction[@"name"];
        annotation.type = [attraction[@"type"] integerValue];
        annotation.subtitle = attraction[@"subtitle"];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)addBoundary {
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:self.mapArea.boundary
                                                     count:self.mapArea.boundaryPointsCount];
    [self.mapView addOverlay:polygon];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor magentaColor];
        
        return polygonView;
    }
    
    return nil;
}
- (void) loadUserLocation
{
    objLocationManager = [[CLLocationManager alloc] init];
    objLocationManager.delegate = self;
    objLocationManager.distanceFilter = kCLDistanceFilterNone;
    objLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([objLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [objLocationManager requestWhenInUseAuthorization];
    }
    [objLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations objectAtIndex:0];
    latitude_UserLocation = newLocation.coordinate.latitude;
    longitude_UserLocation = newLocation.coordinate.longitude;
    [objLocationManager stopUpdatingLocation];
    [self loadMapView];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [objLocationManager stopUpdatingLocation];
}

- (void) loadMapView
{
    CLLocationCoordinate2D objCoor2D = {.latitude = latitude_UserLocation, .longitude = longitude_UserLocation};
    MKCoordinateSpan objCoorSpan = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
    MKCoordinateRegion objMapRegion = {objCoor2D, objCoorSpan};
    //[_mapView setRegion:objMapRegion];
}


-(IBAction)setMap:(id)sender{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            _mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            _mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            _mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }else{
        FestivalAttractionAnnotationView *annotationView = [[FestivalAttractionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}

-(void)btnPinClick{
    NSLog(@"Test");
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
