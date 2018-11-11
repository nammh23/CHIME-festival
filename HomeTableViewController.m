//
//  HomeTableViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/24/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "HomeTableViewController.h"
#import "FestivalInformation.h"
#import "HomeTableViewCell.h"
#import "FestivalScheduleTableViewController.h"
#import "FestivalEvent.h"
#import "NSDate+TimeAgo.h"
@interface HomeTableViewController ()
@property (nonatomic) NSInteger selectedFestivalId;
@property (readwrite) NSMutableArray *listFestival;
@end
@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedFestivalId = 0;
    self.listFestival = [[NSMutableArray alloc] init];
    [FestivalEvent getAllEvent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllEventSuccess:) name:@"allEvent" object:nil];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString* today = @"2017-04-22 12:25:03";//[NSString stringWithFormat:@"%@", [NSDate date]];
    NSDate* test = [f dateFromString:today];
    NSString *ago = [test timeAgo];
    NSLog(@"%@  --- %@ Output is: \"%@\"",test,[NSDate date], ago);
}

-(void)getAllEventSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"allEvent"]) {
        self.listFestival = [notification.userInfo objectForKey:@"allEvent"];
        [_clientTable reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.title = @"Home";
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
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

    return [[self listFestival] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listFestivalTable" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listFestivalTable"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    NSInteger index = [indexPath row];
    if(index >=0 && index < [self.listFestival count] ){
        NSDictionary<NSString *, NSString *> *message = _listFestival[indexPath.row];
        cell.festivalName.text = message[@"name"];
        cell.festivalDate.text = message[@"date"];
        cell.logo.image = [UIImage imageNamed:message[@"avatar"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    FestivalScheduleTableViewController *objScheduleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FestivalSchedule"];
    //objScheduleViewController.festival =
    [self.navigationController pushViewController:objScheduleViewController animated:NO];}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HomeTableViewController* table = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //table. = [[self.listFestival objectAtIndex:indexPath.row] festivalID];
}


@end
