//
//  FestivalScheduleDetailViewController.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/8/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLoader.h"
@interface FestivalScheduleDetailViewController : ActivityLoader
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *festivalTime;
@property (weak, nonatomic) IBOutlet UILabel *festivalPlace;
- (IBAction)addToCalendar:(id)sender;
- (IBAction)goToTicket:(id)sender;
- (IBAction)getDirection:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *festivalDetail;
@property (nonatomic) NSDictionary<NSString *, NSString *> *selectedSchedule;
@end
