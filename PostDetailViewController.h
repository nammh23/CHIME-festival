//
//  PostDetailViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 4/4/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *inforText;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postTxtContraintHeight;

@property (nonatomic) NSDictionary<NSString *, NSString *> *selectedPost;
@end

