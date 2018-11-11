//
//  FestivalScheduleTableViewCell.h
//  CHIME
//
//  Created by Mai Hoai Nam on 3/7/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FestivalScheduleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *scheduleImgView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;

@end
