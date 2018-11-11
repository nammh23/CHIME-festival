//
//  FestivalTimelineTableViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/9/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalTimelineTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPostItem;
@property(nonatomic, weak) IBOutlet UITableView *clientTable;

@end
