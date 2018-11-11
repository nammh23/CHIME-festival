//
//  CommunityTableViewCell.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/29/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UITextView *statusTxt;
@property (weak, nonatomic) IBOutlet UIImageView *postImg;

@end
