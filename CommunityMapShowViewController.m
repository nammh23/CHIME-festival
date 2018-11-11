//
//  CommunityMapShowViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/30/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//


#import "CommunityMapShowViewController.h"
#import "FestivalMap.h"
#import "FestivalAttractionAnnotation.h"
#import "FestivalAttractionAnnotationView.h"
#import "Constants.h"
#import "PostDetailViewController.h"
@interface CommunityMapShowViewController ()
@property (nonatomic, strong) FestivalMap *mapArea;
@property (nonatomic, strong) NSMutableArray *selectedOptions;
@end

@implementation CommunityMapShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.topItem.leftBarButtonItem = _cancelBtnClicked;
    self.navigationController.navigationBar.topItem.title = @"Community Map";
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
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }else{
        FestivalAttractionAnnotation *customAnnotation = (FestivalAttractionAnnotation*)annotation;
        FestivalAttractionAnnotationView *annotationView = [[FestivalAttractionAnnotationView alloc] initWithCustomAnnotation:customAnnotation reuseIdentifier:@"Attraction" image:customAnnotation.profilePic];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    FestivalAttractionAnnotation *annotation = view.annotation;
    PostDetailViewController *destController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    NSDictionary<NSString *, NSString *> *post = [_listPost objectAtIndex:[annotation.aID intValue]];
    destController.selectedPost = post;
    [self.navigationController pushViewController:destController animated:NO];

}


- (IBAction)cancelBtnClicked:(id)sender {
    [[self navigationController] dismissViewControllerAnimated:NO completion:nil];
    //[[self navigationController] popViewControllerAnimated:YES];
    
}
- (void)addAttractionPins {
    for (int i = 0; i<_listPost.count; i++) {
        FestivalAttractionAnnotation *annotation = [[FestivalAttractionAnnotation alloc] init];
        NSString* location = [NSString stringWithFormat:@"{%@,%@}",[_listPost objectAtIndex:i][UserpostLat],[_listPost objectAtIndex:i][UserpostLong]];
        CGPoint point = CGPointFromString(location);
        annotation.aID = [NSString stringWithFormat:@"%d",i];
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title =[_listPost objectAtIndex:i][UserpostFieldsname];
        annotation.type = AttractionCustom;
        annotation.profilePic = [_listPost objectAtIndex:i][UserAvatar];
        annotation.subtitle = [_listPost objectAtIndex:i][UserpostFieldstext];
        [self.mapView addAnnotation:annotation];
    }
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
