//
//  FestivalTimelineTableViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/9/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "FestivalTimelineTableViewController.h"
#import "TimelineTableViewCell.h"
#import "Constants.h"
#import "FestivalGetPost.h"
#import "PostDetailViewController.h"
@import Photos;
@import Firebase;
@import FirebaseStorageUI;
@interface FestivalTimelineTableViewController ()<UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *listPost;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;

@end

@implementation FestivalTimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FestivalGetPost getCurrentUserPost:[FIRAuth auth].currentUser.uid];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllPostSuccess:) name:@"allCurrentUserPost" object:nil];
    _listPost = [[NSMutableArray alloc] init];
    [self configureStorage];
}
-(void)getAllPostSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"allCurrentUserPost"]) {
        self.listPost = [notification.userInfo objectForKey:@"allCurrentUserPost"];
        [_clientTable reloadData];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = _addPostItem;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Timeline";

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureStorage {
    self.storageRef = [[FIRStorage storage] reference];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listPost.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineTableViewCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimelineTableViewCell"];
    }
    
    // Unpack message from Firebase DataSnapshot
    NSDictionary<NSString *, NSString *> *message = _listPost[indexPath.row];
    NSString *imageURL = message[UserpostphotoURL];
    if(imageURL == nil){
        cell.postImage.hidden = YES;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:imageURL];
        [cell.postImage sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    if([message[UserpostFB] isEqualToString:@"YES"]){
        [cell.fbBtn setImage:[UIImage imageNamed:@"FacebookLogo"] forState:UIControlStateNormal];
    }else{
        [cell.fbBtn setImage:[UIImage imageNamed:@"FacebookLogoOff"] forState:UIControlStateNormal];
    }
    if([message[UserpostTW] isEqualToString:@"YES"]){
        [cell.twBtn setImage:[UIImage imageNamed:@"TwitterLogo"] forState:UIControlStateNormal];
    }else{
        [cell.twBtn setImage:[UIImage imageNamed:@"TwitterLogoOff"] forState:UIControlStateNormal];
    }
    cell.postText.text = message[UserpostFieldstext];
    
    return cell;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[[self tableView] indexPathsForSelectedRows] objectAtIndex:0];
    NSLog(@"%c", [segue.identifier isEqualToString:@"showTimelineSegue"]);
    if ([segue.identifier isEqualToString:@"showTimelineSegue"]){
        NSDictionary<NSString *, NSString *> *post = [_listPost objectAtIndex:indexPath.row];
        PostDetailViewController* destController = [segue destinationViewController];
        destController.selectedPost = post;
    }}


@end
