//
//  ProfileViewViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 4/16/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "ProfileViewViewController.h"
#import "ProfileViewTableViewCell.h"
#import "FestivalGetProfile.h"
#import "Constants.h"
@import Firebase;
@import FirebaseStorageUI;
@interface ProfileViewViewController ()
@property (nonatomic, strong) NSMutableArray *listPublicInfor;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *userProfile;
@end

@implementation ProfileViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FestivalGetProfile getOtherUserProfile:_selectedUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllPostSuccess:) name:@"OtherProfile" object:nil];
    _listPublicInfor = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.title = @"Profile";
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
}

-(void)getAllPostSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"OtherProfile"]) {
        self.userProfile = [notification.userInfo objectForKey:@"OtherProfile"];
        [_listPublicInfor removeAllObjects];
        for(NSDictionary *dict in self.userProfile){
            if([[[dict allKeys] objectAtIndex:0] isEqualToString:Username]){
                [_listPublicInfor addObject: @{@"image": @"Fullname",@"name":dict[Username]}];
                self.usernameLable.text = dict[Username];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserNickname]){
                [_listPublicInfor addObject: @{@"image": @"profile",@"name":dict[UserNickname]}];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserBio]){
                [_listPublicInfor addObject: @{@"image": @"Information",@"name":dict[UserBio]}];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserAvatar]){
                [self getProfilePicture:dict[UserAvatar]];
            }
        }
        [_userInforTable reloadData];
    }
}


-(void)getProfilePicture:(NSString*)avatarURL {
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
    if(image != nil){
        self.profileImage.image = image;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:avatarURL];
        [self.profileImage sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _userInforTable){
        ProfileViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewInformation" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[ProfileViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileViewInformation"];
        }
        NSInteger index = [indexPath row];
        if(index >=0 && index < 3 && _listPublicInfor.count >0){
            NSDictionary *infor = [[self listPublicInfor] objectAtIndex:index];
            cell.textDisplay.enabled = NO;
            cell.textDisplay.text = [infor valueForKey:@"name"];
            cell.icon.image = [UIImage imageNamed: [infor valueForKey:@"image" ]];
        }
        return cell;
    }

    
    return nil;
}


@end
