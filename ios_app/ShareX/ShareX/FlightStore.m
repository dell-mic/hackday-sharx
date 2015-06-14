//
//  FlightStore.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "FlightStore.h"

@implementation FlightStore

#pragma mark Singleton Methods

+ (id)sharedFlightStore
{
    static FlightStore *sharedFlightStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFlightStore = [[self alloc] init];
    });
    return sharedFlightStore;
}

- (id)init
{
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MyBookings" ofType:@"plist"];
    NSArray *flightData = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *mutableBookedFlights = [[NSMutableArray alloc] init];
    NSMutableArray *mutableOpenOrders = [[NSMutableArray alloc] init];
    
    int index = 0;
    int threshold = 5;
    for (NSDictionary *flightInfo in flightData) {
        Flight *flight = [Flight flightWithInfo:flightInfo];
        
        if (index++ > threshold) {
            [mutableOpenOrders addObject:flight];
        }
        else {
            [mutableBookedFlights addObject:flight];
        }
    }
    
    _bookedFlights = [[NSArray alloc] initWithArray:mutableBookedFlights];
    _openOrders = [[NSArray alloc] initWithArray:mutableOpenOrders];
    
    NSLog(@"read %ld booked flights", [self.bookedFlights count]);
    NSLog(@"read %ld open orders", [self.openOrders count]);

}


@end
