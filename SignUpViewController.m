//
//  UIViewController+SignUp.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/19/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "SignUpViewController.h"
@import Firebase;
#import "Constants.h"
#import "TabBarViewController.h"
@interface SignUpViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation SignUpViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _ref = [[FIRDatabase database] reference];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
-(void)dismissKeyboard
{
    [_password resignFirstResponder];
    [_emailID resignFirstResponder];
    [_confirmPassword resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackButtonWithTitle:(NSString *)title {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pushDataToFirebaseDatabase:(FIRUser*) user{
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    data[Username] =@"Someone";
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
    data[UserAvatar] = @"gs://chime-25702.appspot.com/profile-icon-9.png";
    [[[_ref child:@"user"] child:user.uid] setValue:data];
    TabBarViewController *tabBarctr = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:tabBarctr animated:NO];
}
-(IBAction)btnSignup:(id)sender{
    if ([self validation]){
        [self showHud];
        [[FIRAuth auth] createUserWithEmail:_emailID.text password:_password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            [self hideHud];
            if (error) {
                [self displayAlertView:error.localizedDescription];
                NSLog(@"Error in FIRAuth := %@",error.localizedDescription);
            }
            else{
                FIRUserProfileChangeRequest* changeRequest = [user profileChangeRequest];
                changeRequest.displayName = @"User's name";
                changeRequest.photoURL = [NSURL URLWithString:@"gs://chime-25702.appspot.com/profile-icon-9.png"];
                
                [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) { }];
                NSLog(@"%@",user.photoURL);
                [self pushDataToFirebaseDatabase:user];
                TSTAlertView *alert = [[TSTAlertView alloc] init];
                alert.backgroundType = Blur;
                alert.showAnimationType = SlideInFromTop;
                [alert showSuccess:self title:@"CHIME" subTitle:@"Successfully signup with Firebase." closeButtonTitle:nil duration:0.0f];
                [alert addButton:@"Okay" actionBlock:^{
                    [self.navigationController popViewControllerAnimated:true];
                }];
            }
        }];
    }
}

-(IBAction)btnLogin:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - All Validation methods
- (BOOL)validation{
    NSString *strEmailID = [_emailID.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    NSString *strPassword = [_password.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *strConfirmPassword = [_confirmPassword.text stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
    if (strEmailID.length <= 0){
        [self displayAlertView:@"Please enter email Id"];
        return NO;
    }
    else if ([self validateEmailAddress:strEmailID] == NO){
        [self displayAlertView:@"Please enter valid email Id"];
        return NO;
    }
    else if (strPassword.length <= 0){
        [self displayAlertView:@"Please enter password"];
        return NO;
    }
    else if (strConfirmPassword.length <= 0){
        [self displayAlertView:@"Please enter confirm password"];
        return NO;
    }
    else if (![strPassword isEqualToString:strConfirmPassword]){
        [self displayAlertView:@"Password and confirm password does not match"];
        return NO;
    }
    
    return YES;
}

-(BOOL)validateEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView  methods
-(void)displayAlertView:(NSString *)strMessage{
    TSTAlertView *alert = [[TSTAlertView alloc] init];
    alert.backgroundType = Blur;
    alert.showAnimationType = SlideInFromTop;
    [alert showError:self title:@"CHIME" subTitle:strMessage closeButtonTitle:@"Okay!" duration:0.0f];
}
@end
