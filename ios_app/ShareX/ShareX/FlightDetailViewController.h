//
//  FlightDetailViewController.h
//  ShareX
//
//  Created by Nikolas Burk on 14/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Flight.h"

@interface FlightDetailViewController : UIViewController

@property (nonatomic, strong) Flight *flight;
@property (nonatomic, assign) BOOL showsPendingOrder;

@end
