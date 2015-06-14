//
//  BookingCell.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"

typedef enum {
    BCT_Voucher = 0,
    BCT_Booking,
    BCT_Archive
} BookingCellType;

@interface BookingCell : UITableViewCell

@property (nonatomic, assign) BookingCellType type;
@property (nonatomic, strong) Flight *flight;



@end
