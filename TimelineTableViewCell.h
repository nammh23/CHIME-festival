//
//  TimelineTableViewCell.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/9/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *twBtn;

@end
