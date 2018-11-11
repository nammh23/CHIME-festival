
//  ProfileViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/27/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "ProfileViewController.h"
#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "LoginViewController.h"
#import "ProfileTableViewCell.h"
#import "FestivalGetProfile.h"
#import "Constants.h"
@import Firebase;
@import FirebaseStorageUI;
@interface ProfileViewController ()
@property (nonatomic, strong) NSMutableArray *listPublicInfor;
@property (nonatomic, strong) NSMutableArray *listPrivateInfor;
@property (nonatomic, strong) NSMutableDictionary* data;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *userProfile;
@property (strong, nonatomic) NSMutableDictionary *saveProfile;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
        if(user){
            [FestivalGetProfile getCurrentUserProfile:user.uid];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllPostSuccess:) name:@"UserProfile" object:nil];
        }
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _ref = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    [_profilePic setUserInteractionEnabled:YES];
    _saveProfile = [[NSMutableDictionary alloc] init];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [_profilePic addGestureRecognizer:singleTap];
    _userProfile = [[NSMutableArray alloc] init];
    _listPublicInfor = [[NSMutableArray alloc] init];
    _listPrivateInfor = [[NSMutableArray alloc] init];
    _data = [[NSMutableDictionary alloc] init];
}
-(void)getAllPostSuccess:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"UserProfile"]) {
        self.userProfile = [notification.userInfo objectForKey:@"UserProfile"];
        [_listPrivateInfor removeAllObjects];
        [_listPublicInfor removeAllObjects];
        for(NSDictionary *dict in self.userProfile){
            if([[[dict allKeys] objectAtIndex:0] isEqualToString:Username]){
                [_listPublicInfor addObject: @{@"image": @"Fullname",@"name":dict[Username]}];
                [_saveProfile setObject:dict[Username] forKey:Username];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserNickname]){
                [_listPublicInfor addObject: @{@"image": @"profile",@"name":dict[UserNickname]}];
                [_saveProfile setObject:dict[UserNickname] forKey:UserNickname];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserBio]){
                [_listPublicInfor addObject: @{@"image": @"Information",@"name":dict[UserBio]}];
                [_saveProfile setObject:dict[UserBio] forKey:UserBio];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserMail]){
                [_listPrivateInfor addObject: @{@"image": @"email",@"name":dict[UserMail]}];
                [_saveProfile setObject:dict[UserMail] forKey:UserMail];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserPhone]){
                [_listPrivateInfor addObject: @{@"image": @"mobile",@"name":dict[UserPhone]}];
                [_saveProfile setObject:dict[UserPhone] forKey:UserPhone];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserGender]){
                [_listPrivateInfor addObject: @{@"image": @"gender",@"name":dict[UserGender]}];
                [_saveProfile setObject:dict[UserGender] forKey:UserGender];
            }else if([[[dict allKeys] objectAtIndex:0] isEqualToString:UserAvatar]){
                [self getProfilePicture:dict[UserAvatar]];
            }
        }
        [_inforTableView reloadData];
    }
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Change Profile Picture"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                         actionWithTitle:@"Take Photo"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             [self presentViewController:picker animated:YES completion:NULL];
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* fromLibrary = [UIAlertAction
                         actionWithTitle:@"Choose From Library"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                             picker.delegate = self;
                             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             [self presentViewController:picker animated:YES completion:NULL];
                             [view dismissViewControllerAnimated:YES completion:nil];
                         }];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:takePhoto];
    [view addAction:fromLibrary];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage =info[UIImagePickerControllerOriginalImage];
    _profilePic.image = pickedImage;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationController.navigationBar.topItem.title = @"Profile";
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = _doneBtn;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getProfilePicture:(NSString*)avatarURL {
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
    if(image != nil){
        self.profilePic.image = image;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:avatarURL];
        [self.profilePic sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (IBAction)logoutBtn:(id)sender{
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (status) {
        LoginViewController *objSignUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:objSignUpViewController animated:NO];
    }else{
        NSLog(@"Error signing out: %@", signOutError);
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    if(section == 0)
        return @"";
    else
        return @"Private information";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _inforTableView){
            ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileInformation" forIndexPath:indexPath];
            if(cell == nil){
                cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileInformation"];
            }
            NSInteger index = [indexPath row];
        if(index >=0 && index < 3){
            if(indexPath.section == 0 && _listPublicInfor.count >0 ){
                NSDictionary *infor = [[self listPublicInfor] objectAtIndex:index];
                cell.textDisplay.delegate = self;
                cell.textDisplay.text = [infor valueForKey:@"name"];
                cell.icon.image = [UIImage imageNamed: [infor valueForKey:@"image" ]];
            }else if(indexPath.section == 1 && _listPrivateInfor.count >0 ){
                NSDictionary *infor = [[self listPrivateInfor] objectAtIndex:index];
                cell.textDisplay.delegate = self;
                cell.textDisplay.text = [infor valueForKey:@"name"];
                cell.icon.image = [UIImage imageNamed: [infor valueForKey:@"image" ]];
            }
        }
        return cell;
    }
    return nil;
}

- (void)sendMessage:(NSDictionary *)mdata {
    NSMutableDictionary *data;
    data = [_saveProfile mutableCopy];
    if(mdata){
        [data setObject:mdata[UserAvatar] forKey:UserAvatar];
    }
    [[[_ref child:@"user"] child:[FIRAuth auth].currentUser.uid] setValue:data];
}

- (IBAction)doneBtnClicked:(id)sender {
    [self showHud];
    UIImage *image = _profilePic.image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *imagePath =
    [NSString stringWithFormat:@"ProfilePicture/%@.jpg",
     [FIRAuth auth].currentUser.uid];
    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
    metadata.contentType = @"image/jpeg";
    [[_storageRef child:imagePath] putData:imageData metadata:metadata
                                completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                                    [self hideHud];
                                    if (error) {
                                        NSLog(@"Error uploading: %@", error);
                                        [self sendMessage:nil];
                                        return;
                                    }
                                    [self sendMessage:@{UserAvatar:[_storageRef child:metadata.path].description}];
                                }];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    ProfileTableViewCell *cell = (ProfileTableViewCell *) textField.superview.superview;
    CGPoint scrollPoint = CGPointMake(-10, textField.frame.origin.y);
    scrollPoint = [_inforTableView convertPoint:scrollPoint fromView:cell];
    [_inforTableView setContentOffset:scrollPoint animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    ProfileTableViewCell *cell = (ProfileTableViewCell *) textField.superview.superview;
    NSIndexPath *indexPath = [_inforTableView indexPathForCell:cell];
    if(indexPath.section == 0 && indexPath.row == 0){
        _saveProfile[UserBio] = newString;
    }else if(indexPath.section == 0 && indexPath.row == 1){
        _saveProfile[Username] = newString;
    }else if(indexPath.section == 0 && indexPath.row == 2){
        _saveProfile[UserNickname] = newString;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        _saveProfile[UserGender] = newString;
    }else if(indexPath.section == 1 && indexPath.row == 1){
        _saveProfile[UserMail] = newString;
    }else if(indexPath.section == 1 && indexPath.row == 2){
        _saveProfile[UserPhone] = newString;
    }

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    ProfileTableViewCell *cell = (ProfileTableViewCell *) textField.superview.superview;
    NSIndexPath *indexPath = [_inforTableView indexPathForCell:cell];
    if(indexPath.section == 0 && indexPath.row == 0){
        _saveProfile[UserBio] = cell.textDisplay.text;
    }else if(indexPath.section == 0 && indexPath.row == 1){
        _saveProfile[Username] = cell.textDisplay.text;
    }else if(indexPath.section == 0 && indexPath.row == 2){
        _saveProfile[UserNickname] = cell.textDisplay.text;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        _saveProfile[UserGender] = cell.textDisplay.text;
    }else if(indexPath.section == 1 && indexPath.row == 1){
        _saveProfile[UserMail] = cell.textDisplay.text;
    }else if(indexPath.section == 1 && indexPath.row == 2){
        _saveProfile[UserPhone] = cell.textDisplay.text;
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
