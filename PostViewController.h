//
//  PostViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/9/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
@interface PostViewController : UIViewController <CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
        NSMutableArray *listPost;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBtn;
@property (weak, nonatomic) IBOutlet UITableView *shareTableView;
- (IBAction)cancelBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
- (IBAction)addPostPhotoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *postText;
- (IBAction)postBtnClicked:(id)sender;
@property(nonatomic) NSMutableArray *listPost;

@end
