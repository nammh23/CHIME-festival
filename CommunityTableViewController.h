//
//  CommunityTableViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/29/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLoader.h"

@interface CommunityTableViewController : ActivityLoader<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UITableView *clientTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapBtn;

@end
