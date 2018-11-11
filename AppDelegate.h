//
//  AppDelegate.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/14/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Firebase/Firebase.h"
@import GoogleSignIn;
#import "FBSDKLoginKit.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

