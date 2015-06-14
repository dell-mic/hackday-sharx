//
//  FlightDetailViewController.m
//  ShareX
//
//  Created by Nikolas Burk on 14/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "FlightDetailViewController.h"
#import "DefaultCell.h"

#define DEFAULT_CELLS 5

#define START_INDEX 0
#define DEST_INDEX 1
#define DATE_INDEX 2
#define FLIGHT_ID_INDEX 3
#define SEAT_CLASS 4


@interface FlightDetailViewController ()


@end

@implementation FlightDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleAccordingToType];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleAccordingToType];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString *DefaultCellId = @"DefaultCell";
    
    if (indexPath.row < DEFAULT_CELLS) {
        cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellId forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case START_INDEX:
                ((DefaultCell *)cell).titleTextLabel.text = @"Departure";
                ((DefaultCell *)cell).defaultDetailLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.flight.departure, self.flight.departureShort];
                break;
            case DEST_INDEX:
                ((DefaultCell *)cell).titleTextLabel.text = @"Destination";
                ((DefaultCell *)cell).defaultDetailLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.flight.destination, self.flight.destinationShort];
                break;
            case DATE_INDEX: {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.yyyy"];
                NSString *dateString = [dateFormat stringFromDate:self.flight.date];
                ((DefaultCell *)cell).titleTextLabel.text = @"Date";
                ((DefaultCell *)cell).defaultDetailLabel.text = dateString;
                break;

            }
            case FLIGHT_ID_INDEX:
                ((DefaultCell *)cell).titleTextLabel.text = @"Flight ID";
                ((DefaultCell *)cell).defaultDetailLabel.text = self.flight.flightId;
                break;
                
            case SEAT_CLASS:
                ((DefaultCell *)cell).titleTextLabel.text = @"Seat Class";
                ((DefaultCell *)cell).defaultDetailLabel.text = self.flight.seatClass;
                break;
            
            default:
                break;
        }
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = DEFAULT_CELLS;
    
    switch (self.type) {
        case FDVC_Archive:
            
            break;
        case FDVC_Booking:
            
            break;
        case FDVC_Voucher:
            
            break;
            
        case FDVC_Pending:
            
            break;
        default:
            break;
    }
    
    return rows;
}


- (void)setFlight:(Flight *)flight
{
    _flight = flight;
}

- (void)setTitleAccordingToType
{
    NSString *title = nil;
    switch (self.type) {
        case FDVC_Booking:
            title = @"My booking";
            break;
        case FDVC_Archive:
            title = @"Archived ticket";
            break;
        case FDVC_Pending:
            title = @"Pending...";
            break;
        case FDVC_Voucher:
            title = @"My voucher";
            break;
        default:
            break;
    }
    self.title = title;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}




@end
