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

@property (nonatomic, strong) NSMutableArray *bookedFlights; // what flights have I booked
@property (nonatomic, strong) NSMutableArray *openOrders; // what are my open orders?

//- (void)addFlight:(Flight *)flight;

+ (id)sharedFlightStore;

@end
