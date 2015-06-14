//
//  FlightDetailViewController.h
//  ShareX
//
//  Created by Nikolas Burk on 14/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Flight.h"

typedef enum {
    FDVC_Booking,
    FDVC_Voucher,
    FDVC_Archive,
    FDVC_Pending
} FlightDetailViewControllerType;

@interface FlightDetailViewController : UITableViewController

@property (nonatomic, strong) Flight *flight;
@property (nonatomic, assign) FlightDetailViewControllerType type;

@end
