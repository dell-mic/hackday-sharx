//
//  Flight.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#define kPrice @"price"
#define kDeparture @"departure"
#define kDepartureShort @"departureShort"
#define kDestination @"destination"
#define kDestinationShort @"destinationShort"
#define kFlightId @"flightId"
#define kDate @"date"
#define kSeatClass @"seatClass"
#define kSeat @"seat"

#import "Flight.h"

@implementation Flight

+ (Flight *)flightWithInfo:(NSDictionary *)flightInfo
{
    NSDate *date = flightInfo[kDate];
    NSString *departure = flightInfo[kDeparture];
    NSString *departureShort = flightInfo[kDepartureShort];
    NSString *destination = flightInfo[kDestination];
    NSString *destinationShort = flightInfo[kDestinationShort];
    NSNumber *price = flightInfo[kPrice];
    NSString *flightId = flightInfo[kFlightId];
    NSString *seatClass = flightInfo[kSeatClass];
    NSString *seat = flightInfo[kSeat];

    Flight *flight = [[Flight alloc] init];
    flight.date = date;
    flight.departure = departure;
    flight.departureShort = departureShort;
    flight.destination = destination;
    flight.destinationShort = destinationShort;
    flight.price = [price doubleValue];
    flight.flightId = flightId;
    flight.seatClass = seatClass;
    flight.seat = seat;
    
    return flight;
    
}

@end
