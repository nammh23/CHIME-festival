//
//  PostDetailViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 4/4/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Constants.h"
#import "ProfileViewViewController.h"
@import Firebase;
@import FirebaseStorageUI;
@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* avatarURL = _selectedPost[UserAvatar];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
    if(image != nil){
        _profileImage.image = image;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:avatarURL];
        [_profileImage sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    _profileImage.clipsToBounds = YES;
    _profileImage.layer.borderWidth = 2.0f;
    _profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [_profileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [_profileImage addGestureRecognizer:singleTap];

    NSString* time = [Constants calculateDate:_selectedPost[UserpostTime]];
    NSString* name = @"";
    if([_selectedPost[UserId] isEqualToString:[FIRAuth auth].currentUser.uid]){
        name = @"You";
    }else{
        name = _selectedPost[UserpostFieldsname];
    }

    NSString* postString = [NSString stringWithFormat:@"%@ posted a new status.\n%@", name, time ];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:12];
    UIColor *color = [UIColor lightGrayColor];
    NSDictionary *dictColor = @{NSForegroundColorAttributeName : color };
    NSRange colorRange = NSMakeRange(postString.length-time.length, time.length);
    NSRange selectedRange = NSMakeRange(0, name.length);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:postString];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, nil];
    [string setAttributes:dictBoldText range:selectedRange];
    [string setAttributes:dictColor range:colorRange];
    _inforText.attributedText = string;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _postText.text = _selectedPost[UserpostFieldstext];
    [_postText sizeToFit];
    _postTxtContraintHeight.constant = _postText.contentSize.height;
    NSString *imageURL = _selectedPost[UserpostphotoURL];
    if(imageURL == nil){
        _postImage.hidden = YES;
    }else{
        FIRStorageReference *reference = [[FIRStorage storage] referenceForURL:imageURL];
        [_postImage sd_setImageWithStorageReference:reference placeholderImage:[UIImage imageNamed:@"placeholder"]];    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.leftBarButtonItem = nil;
    self.navigationController.navigationController.navigationBar.topItem.title = @"Post Detail";

}

-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    if([_selectedPost[UserId] isEqualToString:[FIRAuth auth].currentUser.uid]){
        self.tabBarController.selectedIndex = 3;
    }else{
        ProfileViewViewController* profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
        profileView.selectedUser = _selectedPost[UserId];
        [self.navigationController pushViewController:profileView animated:NO];
    }

}

@end
