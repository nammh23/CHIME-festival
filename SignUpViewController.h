//
//  UIViewController+SignUp.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/19/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLoader.h"
@interface SignUpViewController : ActivityLoader<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailID;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
-(IBAction)btnSignup:(id)sender;
-(IBAction)btnLogin:(id)sender;
@end
