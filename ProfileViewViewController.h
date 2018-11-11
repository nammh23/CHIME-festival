//
//  ProfileViewViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 4/16/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UITableView *userInforTable;
@property (nonatomic) NSString *selectedUser;

@end
