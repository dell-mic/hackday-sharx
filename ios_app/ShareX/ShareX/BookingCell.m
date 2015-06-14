//
//  BookingCell.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "BookingCell.h"

@interface BookingCell()

@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation BookingCell

- (void)setFlight:(Flight *)flight
{
    _flight = flight;
    [self configureUI];
}

- (void)configureUI
{
    NSString *routeString = [NSString stringWithFormat:@"%@, %@ - %@, %@", self.flight.departure, self.flight.departureShort, self.flight.destination, self.flight.destinationShort];
    self.routeLabel.text = routeString;
    
    
    self.flightIdLabel.text = [NSString stringWithFormat:@" (%@)", self.flight.flightId];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormat stringFromDate:self.flight.date];
    self.dateLabel.text = dateString;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%ld,-", (long)self.flight.price];
}

- (void)setType:(BookingCellType)type
{
    _type = type;
    
    switch (type) {
        case BCT_Booking:
            self.priceLabel.textColor =  [UIColor colorWithRed:0.0/255.0 green:204.0/255.0 blue:5.0/255.0 alpha:1.0];
            break;
        case BCT_Voucher:
//            self.priceLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:255.0/255.0 alpha:1.0];
            self.priceLabel.textColor = self.tintColor;
            break;
        case BCT_Archive:
            self.priceLabel.textColor = [UIColor grayColor];

            break;
        default:
            break;
    }
}

@end
