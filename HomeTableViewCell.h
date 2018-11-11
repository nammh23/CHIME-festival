//
//  HomeTableViewCell.h
//  CHIME
//
//  Created by Mai Hoai Nam on 2/24/17.
//  Copyright © 2017 Mai Hoai Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *festivalName;
@property (weak, nonatomic) IBOutlet UILabel *festivalDate;
@end
