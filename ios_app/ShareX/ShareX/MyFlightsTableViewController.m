//
//  MyFlightsTableViewController.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "MyFlightsTableViewController.h"
#import "FlightStore.h"
#import "BookingCell.h"
#import "FlightDetailViewController.h"

#define MY_BOOKINGS_SECTION 0
//#define OPEN_ORDERS_SECTION 1

#define ShowBookingDetailSegue @"ShowBookingDetail"

@interface MyFlightsTableViewController ()

@property (nonatomic, strong) Flight *tappedFlight;

@end

@implementation MyFlightsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"My flights";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MY_BOOKINGS_SECTION) {
        self.tappedFlight = [[FlightStore sharedFlightStore] bookedFlights][indexPath.row];
    }
//    else if (indexPath.section == OPEN_ORDERS_SECTION) {
//        self.tappedFlight = [[FlightStore sharedFlightStore] openOrders][indexPath.row];
//    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString *BookingCellId = @"BookingCell";
    
    if (indexPath.section == MY_BOOKINGS_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:BookingCellId];
        [self configureBookingCell:(BookingCell *)cell atRow:indexPath.row];
        
    }
//    else if (indexPath.section == OPEN_ORDERS_SECTION) {
//        cell = [tableView dequeueReusableCellWithIdentifier:OpenOrderCellId];
//        [self configureOpenOrderCell:(OpenOrderCell *)cell atRow:indexPath.row];
//    }
    
//    NSLog(@"cell %@ for index path: %@", cell, indexPath);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == MY_BOOKINGS_SECTION){
        rows = [[FlightStore sharedFlightStore] bookedFlights].count;
    }
//    else if (section == OPEN_ORDERS_SECTION) {
//        rows = [[FlightStore sharedFlightStore] openOrders].count;
//    }
    
    NSLog(@"return %ld rows for %ld section", rows, section);
    return rows;
}

- (void)configureBookingCell:(BookingCell *)cell atRow:(NSInteger)row
{
    Flight *flight = [[FlightStore sharedFlightStore] bookedFlights][row];
    cell.flight = flight;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    FlightDetailViewController *flightDetailViewController = (FlightDetailViewController *)segue.destinationViewController;
    flightDetailViewController.flight = self.tappedFlight;
    if ([segueID isEqualToString:ShowBookingDetailSegue]) {
        flightDetailViewController.showsPendingOrder = NO;
    }
//    else if ([segueID isEqualToString:ShowPendingOrderDetailSegue]) {
//        flightDetailViewController.showsPendingOrder = YES;
//    }
}

@end
