//
//  PostViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 3/9/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "PostViewController.h"
#import "ShareTableViewCell.h"
#import "LocationTableViewCell.h"
#import "Constants.h"
#import "FestivalPost.h"
#import "FBSDKShareKit/FBSDKShareKit.h"
#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import <TwitterKit/TwitterKit.h>
@import Firebase;
@import Photos;
@interface PostViewController ()
@property (nonatomic, strong) NSMutableArray *listSocialNetwork;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@property (strong, nonatomic) NSString* fbStatus;
@property (strong, nonatomic) NSString* twStatus;
@end

@implementation PostViewController
@synthesize listPost;
- (void)viewDidLoad {
    [super viewDidLoad];
    listPost = [[NSMutableArray alloc] init];
    _ref = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    _postText.delegate = self;
    _postText.text = @"What's on your mind?";
    _postText.textColor = [UIColor lightGrayColor];
    _fbStatus = @"NO";
    _twStatus = @"NO";
    NSDictionary *facebook = @{@"image": @"FacebookLogoOff", @"name": @"Facebook"};
    NSDictionary *twitter = @{@"image": @"TwitterLogoOff", @"name": @"Twitter"};
    self.listSocialNetwork = [[NSMutableArray alloc] init];
    [self.listSocialNetwork addObject:facebook];
    [self.listSocialNetwork addObject:twitter];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.topItem.rightBarButtonItem = _postBtn;
    self.navigationController.navigationBar.topItem.leftBarButtonItem = _cancelBtn;
    self.navigationController.navigationBar.topItem.title = @"Post";
    
}
-(void)dismissKeyboard
{
    [_postText resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Share your post";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _shareTableView){
        if(indexPath.section == 0){
            ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareSociaNetwork" forIndexPath:indexPath];
            if(cell == nil){
                cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShareSociaNetwork"];
            }
            NSInteger index = [indexPath row];
            if(index >=0 && index < [self.listSocialNetwork count] ){
                NSDictionary *socialNetwork = [[self listSocialNetwork] objectAtIndex:index];
                cell.name.text = [socialNetwork valueForKey:@"name"];
                cell.status.on = NO;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchView;
                //[switchView release];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.logo.image = [UIImage imageNamed: [socialNetwork valueForKey:@"image" ]];
            }
            return cell;
        }
    }
    return nil;
}
- (void)switchChanged:(id)sender {
    UISwitch *switchInCell = (UISwitch *)sender;
    ShareTableViewCell * cell = (ShareTableViewCell*) switchInCell.superview;
    NSIndexPath * indexpath = [_shareTableView indexPathForCell:cell];
    switch (indexpath.row) {
        case 0:
            if(switchInCell.on){
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
                    cell.logo.image = [UIImage imageNamed:@"FacebookLogo"];
                    _fbStatus = @"YES";
                } else {
                    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                    [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                                           fromViewController:self
                                                      handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                          NSLog(@"%@",result);
                                                          if (result.grantedPermissions) {
                                                              cell.logo.image = [UIImage imageNamed:@"FacebookLogo"];
                                                              _fbStatus = @"YES";
                                                          }else{
                                                              cell.logo.image = [UIImage imageNamed:@"FacebookLogoOff"];
                                                              _fbStatus = @"NO";
                                                              [switchInCell setOn:NO];                                                          }
                                                      }];
                }
            }else{
                cell.logo.image = [UIImage imageNamed:@"FacebookLogoOff"];
                _fbStatus = @"NO";

            }
                break;
        case 1:
            if(switchInCell.on){
                [[Twitter sharedInstance] logInWithCompletion:^
                 (TWTRSession *session, NSError *error) {
                     if(!error){
                         cell.logo.image = [UIImage imageNamed:@"TwitterLogo"];
                         _twStatus = @"YES";
                     }else{
                         [switchInCell setOn:NO];
                     }
                 }];
            }else{
                cell.logo.image = [UIImage imageNamed:@"TwitterLogoOff"];
                _twStatus = @"NO";
            }
            break;
        default:
            break;
    }
    NSLog( @"The switch is %@", switchInCell.on ? @"ON" : @"OFF" );
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"What's on your mind?"]) {
        textView.text = @"  #gmlstnjazz #gmlstnjazz2017";
        textView.textColor = [UIColor blackColor];
    }
    [self performSelector:@selector(setCursorToBeginning:) withObject:textView afterDelay:0.001];
    [textView becomeFirstResponder];
}

- (void)setCursorToBeginning:(UITextView *)inView
{
    //you can change first parameter in NSMakeRange to wherever you want the cursor to move
    inView.selectedRange = NSMakeRange(0, 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"What's on your mind?";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[self navigationController] popViewControllerAnimated:YES];

}

- (IBAction)addPostPhotoClicked:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Choose Your Picture"
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
                                    [self presentViewController:picker animated:YES completion:NULL];                             [view dismissViewControllerAnimated:YES completion:nil];
                                    
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
    _postImage.image = pickedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendMessage:(NSDictionary *)data {
    //FestivalPost *post = [[FestivalPost alloc] init];
    NSMutableDictionary *mdata;
    if(data){
        mdata = [data mutableCopy];
    }else{
        mdata = [[NSMutableDictionary alloc] init];
    }
    CLLocationCoordinate2D coordinate = [self getLocation];
    mdata[UserpostLat] = [NSString stringWithFormat:@"%f", coordinate.latitude];
    mdata[UserpostLong] = [NSString stringWithFormat:@"%f", coordinate.longitude];
    mdata[UserpostFieldstext] = _postText.text;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    mdata[UserpostTime] = [NSString stringWithFormat:@"%@", [NSDate date]];
    mdata[UserpostFB] = _fbStatus;
    mdata[UserpostTW] = _twStatus;
    // Push data to Firebase Database
    [listPost addObject:mdata];
    [[[[_ref child:@"userpost"] child:[FIRAuth auth].currentUser.uid] childByAutoId] setValue:mdata];
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}
- (IBAction)postBtnClicked:(id)sender {
    if(_postImage.image){
        UIImage *image = _postImage.image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSString *imagePath =
        [NSString stringWithFormat:@"PostImage/%@/%lld.jpg",
         [FIRAuth auth].currentUser.uid,
         (long long)([NSDate date].timeIntervalSince1970 * 1000.0)];
        FIRStorageMetadata *metadata = [FIRStorageMetadata new];
        metadata.contentType = @"image/jpeg";
        [[_storageRef child:imagePath] putData:imageData metadata:metadata
                                    completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                                        if (error) {
                                            NSLog(@"Error uploading: %@", error);
                                            [self sendMessage:nil];
                                            return;
                                        }
                                        [self sendMessage:@{UserpostphotoURL:[_storageRef child:metadata.path].description}];
                                        //mdata[UserpostphotoURL] = [_storageRef child:metadata.path].description;
                                    }];
        if([_fbStatus isEqualToString:@"YES"]){
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            photo.image = image;
            photo.userGenerated = YES;
            photo.caption = _postText.text;
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            content.photos = @[photo];
            content.hashtag = [FBSDKHashtag hashtagWithString:@"#gmlstnjazz"];
            [FBSDKShareAPI shareWithContent:content delegate:nil];
        }
        if([_twStatus isEqualToString:@"YES"]){
            TWTRAPIClient *twitterClient = [[TWTRAPIClient alloc] initWithUserID:[[Twitter sharedInstance] sessionStore].session.userID];
            NSData *imgData = UIImagePNGRepresentation(image);
            NSString *imageString = [imageData base64EncodedStringWithOptions:0];
            NSString *media = @"https://upload.twitter.com/1.1/media/upload.json";
            NSError *error;
            NSURLRequest *request = [twitterClient URLRequestWithMethod:@"POST" URL:media parameters:@{@"media":imageString} error:&error];
            if (!imgData) {
                NSLog( @"ERROR: could not make nsdata out of image");
                return;
            }
            
            [twitterClient sendTwitterRequest:request completion:^(NSURLResponse *urlResponse, NSData *data, NSError *connectionError) {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:0
                                      error:&jsonError];
                NSString* mediaID = [json objectForKey:@"media_id_string"];
                NSDictionary* message = @{@"status": _postText.text, @"wrap_links": @"true", @"media_ids": mediaID};
                
                NSURLRequest *request = [twitterClient URLRequestWithMethod:@"POST" URL:@"https://api.twitter.com/1.1/statuses/update.json" parameters:message error:&connectionError];
                
                [twitterClient sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    if (connectionError) {
                        NSLog(@"error %@",[connectionError localizedDescription]);
                    } else {
                        NSError *jsonError;
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        NSLog(@"json Finish! %@",json);
                    }
                }];
            }];
        }
    }else{
        [self sendMessage:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
