//
//  HomeTableViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/24/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *clientTable;

@end
