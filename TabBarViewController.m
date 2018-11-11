//
//  TabBarViewController.m
//  CHIME
//
//  Created by Mai Hoai Nam on 2/21/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"
@import Firebase;
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
        if(user){

        }else{
            LoginViewController *objSignUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.navigationController pushViewController:objSignUpViewController animated:NO];

        }
                   }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
