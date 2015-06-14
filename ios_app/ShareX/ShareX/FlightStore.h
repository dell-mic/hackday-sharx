//
//  FlightStore.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flight.h"

@interface FlightStore : NSObject

@property (nonatomic, strong) NSArray *bookedFlights; // what flights have I booked
@property (nonatomic, strong) NSArray *openOrders; // what are my open orders?

+ (id)sharedFlightStore;

@end
