//
//  PendingOrdersTableViewController.m
//  ShareX
//
//  Created by Nikolas Burk on 14/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "PendingOrdersTableViewController.h"
#import "FlightStore.h"
#import "OpenOrderCell.h"
#import "FlightDetailViewController.h"

#define ShowPendingOrderDetailSegue @"ShowPendingOrderDetail"


@interface PendingOrdersTableViewController ()

@property (nonatomic, strong) Flight *tappedFlight;

@end

@implementation PendingOrdersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Pending orders";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tappedFlight = [[FlightStore sharedFlightStore] openOrders][indexPath.row];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [[FlightStore sharedFlightStore] openOrders].count;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OpenOrderCellId = @"OpenOrderCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OpenOrderCellId forIndexPath:indexPath];
    [self configureOpenOrderCell:(OpenOrderCell *)cell atRow:indexPath.row];
    
    return cell;
}

- (void)configureOpenOrderCell:(OpenOrderCell *)cell atRow:(NSInteger)row
{
    Flight *flight = [[FlightStore sharedFlightStore] openOrders][row];
    cell.flight = flight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    FlightDetailViewController *flightDetailViewController = (FlightDetailViewController *)segue.destinationViewController;
    flightDetailViewController.flight = self.tappedFlight;
    if ([segueID isEqualToString:ShowPendingOrderDetailSegue]) {
        flightDetailViewController.type = FDVC_Pending;
    }
}

@end
