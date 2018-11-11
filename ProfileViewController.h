//
//  ProfileViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/27/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "ActivityLoader.h"
@interface ProfileViewController : ActivityLoader <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
- (IBAction)logoutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *inforTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@end
