//
//  ActivityLoader.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/19/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHActivityView.h"
#import "Reachability.h"
#import "TSTAlertView.h"

@interface ActivityLoader : UIViewController
{
    SHActivityView *spinnerMedium; // White spinner
}
@property (strong, nonatomic) IBOutlet UIView *viewOuter;
- (BOOL)isNetworkReachable;
- (void)showNoNetwokMessage;
- (void)showHud;
- (void)hideHud;
-(void)showMessage:(NSString*)message withTitle:(NSString *)title;
@end
