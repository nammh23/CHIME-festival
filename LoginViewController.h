//
//  ViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/14/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "ActivityLoader.h"
@import GoogleSignIn;
@interface LoginViewController : ActivityLoader<GIDSignInUIDelegate, GIDSignInDelegate>
@property (weak, nonatomic) IBOutlet GIDSignInButton *GGsignInButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *LogoButton;
@property (weak, nonatomic) IBOutlet UIButton *FBButton;
@property (weak, nonatomic) IBOutlet UIButton *TWButton;
@property (weak, nonatomic) IBOutlet UIButton *GGButton;
@property (weak, nonatomic) IBOutlet UIImageView *BGImage;
@property (strong, nonatomic) IBOutlet UITextField *emailID;
@property (strong, nonatomic) IBOutlet UITextField *password;
-(IBAction)btnSignUp:(id)sender;
-(IBAction)btnLogin:(id)sender;

@end

