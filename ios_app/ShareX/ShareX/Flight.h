//
//  Flight.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (nonatomic, strong) NSString *flightId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *departure;
@property (nonatomic, strong) NSString *departureShort;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSString *destinationShort;
@property (nonatomic, strong) NSString *seatClass;
@property (nonatomic, strong) NSString *seat;
@property (nonatomic, assign) double price;

+ (Flight *)flightWithInfo:(NSDictionary *)flightInfo;


@end
