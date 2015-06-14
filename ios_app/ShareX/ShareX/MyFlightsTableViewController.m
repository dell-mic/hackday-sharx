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

#define MY_VOUCHERS_SECTION 0
#define MY_BOOKINGS_SECTION 1
#define ARCHIVE_SECTION 2

#define NUMBER_OF_SECTIONS 3

#define nVouchers 2
#define nBookings 4
#define nArchive 1

#define ShowBookingDetailSegue @"ShowBookingDetail"
#define ShowVoucherDetailSegue @"ShowVoucherDetail"
#define ShowArchiveDetailSegue @"ShowArchiveDetail"

@interface MyFlightsTableViewController ()

@property (nonatomic, strong) Flight *tappedFlight;
@property (nonatomic, assign) NSInteger tappedSection;

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
    self.tappedFlight = [[FlightStore sharedFlightStore] bookedFlights][indexPath.row];
    self.tappedSection = indexPath.section;
    NSLog(@"tapped section: %ld", self.tappedSection);

    FlightDetailViewController *flightDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlightDetailViewController"];
    flightDetailViewController.flight = self.tappedFlight;

    if (self.tappedSection == MY_BOOKINGS_SECTION) {
        flightDetailViewController.type = FDVC_Booking;
    }
    else if (self.tappedSection == MY_VOUCHERS_SECTION) {
        flightDetailViewController.type = FDVC_Voucher;
    }
    else if (self.tappedSection == ARCHIVE_SECTION) {
        flightDetailViewController.type = FDVC_Archive;
    }
    
    [self.navigationController pushViewController:flightDetailViewController animated:YES];
    
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString *BookingCellId = @"BookingCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:BookingCellId];
    [self configureBookingCell:(BookingCell *)cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (section == MY_BOOKINGS_SECTION){
        rows = nBookings;
    }
    else if (section == MY_VOUCHERS_SECTION) {
        rows = nVouchers;
    }
    else if (section == ARCHIVE_SECTION) {
        rows = nArchive;
    }
    return rows;
}

- (void)configureBookingCell:(BookingCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Flight *flight = [[FlightStore sharedFlightStore] bookedFlights][indexPath.row];
    if (indexPath.section == MY_BOOKINGS_SECTION){
        cell.type = BCT_Booking;
    }
    else if (indexPath.section == MY_VOUCHERS_SECTION) {
        cell.type = BCT_Voucher;
    }
    else if (indexPath.section == ARCHIVE_SECTION) {
        cell.type = BCT_Archive;
    }
    cell.flight = flight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == MY_BOOKINGS_SECTION){
        title = @"Booked flights";
    }
    else if (section == MY_VOUCHERS_SECTION) {
        title = @"Vouchers";
    }
    else if (section == ARCHIVE_SECTION) {
        title = @"Archive";
    }
    return title;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue: %@", segue.identifier);
    FlightDetailViewController *flightDetailViewController = (FlightDetailViewController *)segue.destinationViewController;
    flightDetailViewController.flight = self.tappedFlight;
    if (self.tappedSection == MY_BOOKINGS_SECTION) {
        flightDetailViewController.type = FDVC_Booking;
    }
    else if (self.tappedSection == MY_VOUCHERS_SECTION) {
        flightDetailViewController.type = FDVC_Voucher;
    }
    else if (self.tappedSection == ARCHIVE_SECTION) {
        flightDetailViewController.type = FDVC_Archive;
    }
}

@end
