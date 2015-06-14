//
//  FlightStore.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "FlightStore.h"

#define kPrice @"price"
#define kDeparture @"departure"
#define kDepartureShort @"departureShort"
#define kDestination @"destination"
#define kDestinationShort @"destinationShort"
#define kFlightId @"flightId"
#define kDate @"date"
#define kSeatClass @"seatClass"
#define kSeat @"seat"

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

- (void)addFlight
{
    NSMutableDictionary *flightInfo = [[NSMutableDictionary alloc] init];
    flightInfo[kDeparture] = @"Hamburg";
    flightInfo[kDepartureShort] = @"HAM";
    flightInfo[kDestination] = @"Frankfurt";
    flightInfo[kDestinationShort] = @"FRA";
    flightInfo[kPrice] = @(80.0);
    flightInfo[kDate] = [self date];
    flightInfo[kSeatClass] = @"Economy";
    Flight *flight = [Flight flightWithInfo:flightInfo];
    [self.openOrders addObject:flight];
}

- (NSDate *)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Extract date components into components1
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setCalendar:gregorianCalendar];
    [components setYear:2015];
    [components setMonth:7];
    [components setDay:14];
    
    // Generate a new NSDate from components3.
    NSDate *combinedDate = [gregorianCalendar dateFromComponents:components];
    return combinedDate;
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
    
    _bookedFlights = [[NSMutableArray alloc] initWithArray:mutableBookedFlights];
    _openOrders = [[NSMutableArray alloc] initWithArray:mutableOpenOrders];
    
    NSLog(@"read %ld booked flights", [self.bookedFlights count]);
    NSLog(@"read %ld open orders", [self.openOrders count]);
    
    [self addFlight];

}


@end
