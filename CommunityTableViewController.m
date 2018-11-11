//
//  CommunityTableViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/29/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "CommunityTableViewController.h"
#import "CommunityTableViewCell.h"
#import "Constants.h"
#import "FestivalGetPost.h"
#import "CommunityMapShowViewController.h"
#import "PostDetailViewController.h"
@import FirebaseStorageUI;
@import CoreText;
@import Photos;
@import Firebase;
@interface CommunityTableViewController ()<UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *listPost;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *listLastPost;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;

@end

@implementation CommunityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showHud];
    [FestivalGetPost getAllPost ];
    [FestivalGetPost getLastUserPost];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllPostSuccess:) name:@"allPost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllLastPostSuccess:) name:@"allLastUserPost" object:nil];
    _listPost = [[NSMutableArray alloc] init];
    _listLastPost = [[NSMutableArray alloc] init];
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = _mapBtn;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Community";
    [self configureStorage];
}
-(void)getAllPostSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"allPost"]) {
        [self hideHud];
        self.listPost = [notification.userInfo objectForKey:@"allPost"];
        [_clientTable reloadData];
    }
}
-(void)getAllLastPostSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"allLastUserPost"]) {
        self.listLastPost = [notification.userInfo objectForKey:@"allLastUserPost"];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = _mapBtn;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Community";
    
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
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityTableViewCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[CommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommunityTableViewCell"];
    }
    
    // Unpack message from Firebase DataSnapshot
    NSDictionary<NSString *, NSString *> *message = _listPost[indexPath.row];
    NSString *imageURL = message[UserpostphotoURL];
    if(imageURL == nil){
        cell.postImg.hidden = YES;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:imageURL];
        [cell.postImg sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    NSString* time =  [Constants calculateDate:message[UserpostTime]];
    NSString* name = @"";
    if([message[UserId] isEqualToString:[FIRAuth auth].currentUser.uid]){
        name = @"You";
    }else{
        name = message[UserpostFieldsname];
    }
    
    NSString* postString = [NSString stringWithFormat:@"%@ posted a new status: \"%@\".\n%@", name, message[UserpostFieldstext],time ];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:12];
    UIColor *color = [UIColor lightGrayColor];
    NSDictionary *dictColor = @{NSForegroundColorAttributeName : color };
    NSRange colorRange = NSMakeRange(postString.length-time.length, time.length);
    NSRange selectedRange = NSMakeRange(0, name.length);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:postString];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, nil];
    [string setAttributes:dictBoldText range:selectedRange];
    [string setAttributes:dictColor range:colorRange];
    cell.statusTxt.attributedText = string;
    
    NSString* avatarURL = message[UserAvatar];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
    if(image != nil){
        cell.userAvatarImg.image = image;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:avatarURL];
        [cell.userAvatarImg sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    cell.userAvatarImg.layer.cornerRadius = cell.userAvatarImg.frame.size.width/2;
    cell.userAvatarImg.clipsToBounds = YES;
    cell.userAvatarImg.layer.borderWidth = 2.0f;
    cell.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;

    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [[[self clientTable] indexPathsForSelectedRows] objectAtIndex:0];
    UINavigationController* navController = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"mapSegue"]){
        CommunityMapShowViewController* map = (CommunityMapShowViewController*)navController.topViewController;
        //UPDATE USERNAME WHEN USER CHANGE IT.u
        map.listPost = self.listLastPost;

    }else if ([segue.identifier isEqualToString:@"showPostSegue"]){
        NSDictionary<NSString *, NSString *> *post = [_listPost objectAtIndex:indexPath.row];
        PostDetailViewController* destController = [segue destinationViewController];
        destController.selectedPost = post;
    }
}


@end
