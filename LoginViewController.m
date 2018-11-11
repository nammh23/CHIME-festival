//
//  FBViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/14/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "LoginViewController.h"
#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "SignUpViewController.h"
#import "TabBarViewController.h"
#import "Constants.h"
@import Firebase;
@import FirebaseAuth;
@import GoogleSignIn;
#import <TwitterKit/TwitterKit.h>

@interface LoginViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *messages;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = [[FIRDatabase database] reference];
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    self.storageRef = [[FIRStorage storage] reference];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.navigationItem.hidesBackButton = YES;

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    // Handle clicks on the Facebook login button
    [_FBButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    // Handle clicks on the Twitter login button
    [_TWButton addTarget:self action:@selector(loginTWButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_GGButton addTarget:self action:@selector(loginGGButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)dismissKeyboard
{
    [_password resignFirstResponder];
    [_emailID resignFirstResponder];
}
- (IBAction)forgotBtnClicked:(id)sender {
    if ([self validateEmailAddress:_emailID.text]){
        [[FIRAuth auth] sendPasswordResetWithEmail:_emailID.text completion:^(NSError *_Nullable error) {
            if(error){
                
            }else{
                [self displayAlertView:@"Email sent! Check your email please."];
            }
         }];

    }
}

-(void)loginGGButtonClicked{
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}

-(IBAction)btnSignUp:(id)sender
{
    SignUpViewController *objSignUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    [self.navigationController pushViewController:objSignUpViewController animated:NO];
}

-(IBAction)btnLogin:(id)sender{
    if ([self validation]){
        [self showHud];
        [[FIRAuth auth] signInWithEmail:_emailID.text password:_password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            [self hideHud];
            if (error) {
                [self displayAlertView:error.localizedDescription];
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                TSTAlertView *alert = [[TSTAlertView alloc] init];
                alert.backgroundType = Blur;
                alert.showAnimationType = SlideInFromTop;
                [alert showSuccess:self title:@"CHIME" subTitle:@"Welcome back" closeButtonTitle:nil duration:0.0f];
                [alert addButton:@"Okay" actionBlock:^{
                    TabBarViewController *tabBarctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                    [self.navigationController pushViewController:tabBarctr animated:NO];
                    
                }];
            }
        }];
    }

}

-(void)pushDataToFirebaseDatabase:(FIRUser*) user{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[Username] = user.displayName;
    if(user.email != nil){
        data[UserMail] = user.email;
        data[UserNickname] = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    }else{
        data[UserMail] = @"Email";
        data[UserNickname] = @"Nickname";
    }
    data[UserBio] = @"Bio";
    data[UserPhone] = @"Phone number";
    data[UserGender] = @"Gender";
    data[UserAvatar] = [NSString stringWithFormat:@"%@",user.photoURL];
    [[[_ref child:@"user"] child:user.uid] setValue:data];
    TabBarViewController *tabBarctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:tabBarctr animated:NO];
}

-(void)loginTWButtonClicked
{
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             FIRAuthCredential *credential =
             [FIRTwitterAuthProvider credentialWithToken:session.authToken
                                                  secret:session.authTokenSecret];
             
             [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user,NSError *error) {
                 if (user) {
                     [self pushDataToFirebaseDatabase:user];
                 }
             }];
         } else {
             NSLog(@"Checkkkkkk error: %@", [error localizedDescription]);
         }
     }];
}

-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                              credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                              .tokenString];
             
             [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user,NSError *error) {
                 if (user) {
                     [self pushDataToFirebaseDatabase:user];
                 }
             }];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            if(user){
                [self pushDataToFirebaseDatabase:user];
            }
        }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}


#pragma mark - All Validation methods

-(BOOL)validation{
    NSString *strEmailID = [_emailID.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [_password.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    if (strEmailID.length <= 0){
        [self displayAlertView:@"Please enter email Id"];
        return NO;
    }
    else if (strPassword.length <= 0){
        [self displayAlertView:@"Please enter password"];
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        [self displayAlertView:@"Please enter valid email Id"];
        return NO;
    }
    return YES;
}

-(BOOL)validateEmailAddress:(NSString *)checkString
{
    if (checkString.length <= 0){
        [self displayAlertView:@"Please enter email Id"];
        return NO;
    }else{
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    }
}


#pragma mark - UIAlertView  methods
-(void)displayAlertView:(NSString *)strMessage
{
    TSTAlertView *alert = [[TSTAlertView alloc] init];
    alert.backgroundType = Blur;
    alert.showAnimationType = SlideInFromTop;
    [alert showError:self title:@"CHIME" subTitle:strMessage closeButtonTitle:@"Okay!" duration:0.0f];
}



@end
