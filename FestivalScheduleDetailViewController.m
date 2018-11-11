//
//  FestivalScheduleDetailViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/8/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalScheduleDetailViewController.h"
#import "FestivalSchedule.h"
#import <EventKit/EventKit.h>
#import "FestivalDirectionMapViewController.h"
#import "Constants.h"
@import Firebase;
@interface FestivalScheduleDetailViewController ()
@property (readwrite) NSMutableArray *listSchedule;
@property (nonatomic) CLLocationCoordinate2D location;

@end

@implementation FestivalScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GMLSTNAttractions" ofType:@"plist"];
    NSArray *attractions = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *attraction in attractions) {
        if([attraction[@"id"] isEqualToString: _selectedSchedule[@"place"]]){
            CGPoint point = CGPointFromString(attraction[@"location"]);
            [self festivalPlace].text = attraction[@"name"];
            self.location = CLLocationCoordinate2DMake(point.x, point.y);
        }
    }
    NSArray* arr = [_selectedSchedule[@"image"] componentsSeparatedByString:@"/"];
    NSString *photoPath = arr[arr.count-1];
    NSString* avatarPath = [[Constants getPostPhotoDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", photoPath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:avatarPath] == NO) {
        NSString *imageURL = _selectedSchedule[@"image"];
        if(imageURL == nil){
            [self coverView].hidden = YES;
        }else{
            if ([imageURL hasPrefix:@"gs://"]) {
                [[[FIRStorage storage] referenceForURL:imageURL] dataWithMaxSize:INT64_MAX
                                                                      completion:^(NSData *data, NSError *error) {
                                                                          if (error) {
                                                                              NSLog(@"Error downloading: %@", error);
                                                                              return;
                                                                          }
                                                                          UIImage *image = [UIImage imageWithData:data];
                                                                          [self coverView].image = image;
                                                                          [UIImagePNGRepresentation(image) writeToFile:avatarPath atomically:YES];
                                                                      }];
            } else {
                UIImage *image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                [self coverView].image  = image;
                [UIImagePNGRepresentation(image) writeToFile:avatarPath atomically:YES];
            }
        }
    }else{
        [self coverView].image  = [UIImage imageWithContentsOfFile:avatarPath];
    }
    [self artistName].text = _selectedSchedule[@"name"];
    [self festivalTime].text = _selectedSchedule[@"date"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self festivalDetail].text = _selectedSchedule[@"detail"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Event Detail";
}


- (IBAction)addToCalendar:(id)sender {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = _selectedSchedule[@"name"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
        //NSDate *date = [dateFormat dateFromString:_selectedSchedule[@"date"]];
        event.startDate = [dateFormat dateFromString:_selectedSchedule[@"start"]];
        event.endDate = [dateFormat dateFromString:_selectedSchedule[@"end"]];
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent error:&err];
        if(!err){
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               NSString *welcomeMessage = [NSString stringWithFormat:@"Event added to calendar"];
                               UIAlertView *alert = [[UIAlertView alloc]
                                                     initWithTitle:@"CHIME" message:welcomeMessage
                                                     delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                               [alert show];
                           });

        }
    }];
}

- (IBAction)goToTicket:(id)sender {
    NSString* url = _selectedSchedule[@"ticketlink"];
    if([url isEqualToString:@"Free Entrance"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"CHIME" message:@"Free Entrance"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

- (IBAction)getDirection:(id)sender {
    
    FestivalDirectionMapViewController *objDirectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FestivalDirection"];
    objDirectionViewController.desLocation = [self location];
    [self.navigationController pushViewController:objDirectionViewController animated:NO];



}
@end
