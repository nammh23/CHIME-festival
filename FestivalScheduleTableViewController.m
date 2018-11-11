//
//  FestivalScheduleTableViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalScheduleTableViewController.h"
#import "FestivalSchedule.h"
#import "FestivalScheduleTableViewCell.h"
#import "FestivalScheduleDetailViewController.h"
#import "FestivalGetSchedule.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import FirebaseStorageUI;
@import Firebase;
@interface FestivalScheduleTableViewController ()
@property (readwrite) NSMutableDictionary *listAllSchedule;
@property (readwrite) NSMutableArray* listSchedule;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation FestivalScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listAllSchedule = [[NSMutableDictionary alloc] init];
    self.listSchedule = [[NSMutableArray alloc] init];
    [self configureStorage];
    [FestivalGetSchedule getAllSchedule:@"festivalSchedule" ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllEventSuccess:) name:@"allSchedule" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Festival Schedule";
    
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}


-(void)getAllEventSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"allSchedule"]) {
        self.listAllSchedule = [notification.userInfo objectForKey:@"allSchedule"];
        NSDictionary* dicts = _listAllSchedule[@"GMLSTN"];
        NSArray* keys = [dicts allKeys];
        [_listSchedule removeAllObjects];
        for(NSString* key in keys){
            [_listSchedule addObject:[dicts objectForKey:key]];
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]; //sort by date key, ascending
        NSArray *arrayOfDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        [_listSchedule sortUsingDescriptors: arrayOfDescriptors];
        [_clientTable reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self listSchedule] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FestivalScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listScheduleTable" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[FestivalScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listScheduleTable"];
    }
    NSInteger index = [indexPath row];
    if(index >=0 && index < [self.listSchedule count] ){
        NSDictionary<NSString *, NSString *> *message = [_listSchedule objectAtIndex:index];
        NSString *imageURL = message[@"image"];
        if(imageURL == nil){
            cell.scheduleImgView.hidden = YES;
        }else{
            FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:imageURL];
            [cell.scheduleImgView sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
/*            NSArray* name = [imageURL componentsSeparatedByString:@"/"];
            NSString *photoPath = name[name.count-1];
            NSString* avatarPath = [[Constants getPostPhotoDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", photoPath]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:avatarPath] == NO) {
                cell.scheduleImgView.hidden = NO;
                if ([imageURL hasPrefix:@"gs://"]) {
                    [[[FIRStorage storage] referenceForURL:imageURL] dataWithMaxSize:INT64_MAX
                                                                          completion:^(NSData *data, NSError *error) {
                                                                              if (error) {
                                                                                  NSLog(@"Error downloading: %@", error);
                                                                                  return;
                                                                              }
                                                                              UIImage *image = [UIImage imageWithData:data];
                                                                              cell.scheduleImgView.image = image;
                                                                              [UIImagePNGRepresentation(image) writeToFile:avatarPath atomically:YES];
                                                                          }];
                } else {
                    UIImage *image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    cell.scheduleImgView.image = image;
                    [UIImagePNGRepresentation(image) writeToFile:avatarPath atomically:YES];
                }
            }else{
                cell.scheduleImgView.image = [UIImage imageWithContentsOfFile:avatarPath];
            }
 */
        }
        cell.eventName.text = message[@"name"];
        cell.eventTime.text = message[@"date"];
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[[self tableView] indexPathsForSelectedRows] objectAtIndex:0];
    NSDictionary<NSString *, NSString *> *schedule = [_listSchedule objectAtIndex:indexPath.row];
    //FestivalSchedule *schedule = [self.listSchedule objectAtIndex:indexPath.row];
    FestivalScheduleDetailViewController* destController = [segue destinationViewController];
    destController.selectedSchedule = schedule;

}


@end
