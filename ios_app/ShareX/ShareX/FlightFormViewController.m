//
//  FlightFormViewController.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#include <stdlib.h>
#import "FlightFormViewController.h"
#import "DepartureCell.h"
#import "ConfirmButtonCell.h"
#import "CurrentPriceCell.h"

#define ROWS 7

#define HEADER_INDEX 0
#define START_INDEX 1
#define DESTINATION_INDEX 2
#define FLIGHT_CLASS_INDEX 3
#define DATE_INDEX 4
#define PRICE_INDEX 5
#define CONFIRM_INDEX 6
#define EMPTY_INDEX 7

#define HEADER_HEIGHT 180.0
#define DATE_PICKER_HEIGHT 200.0
#define CONFIRM_BUTTON_HEIGHT 55.0
#define PRICE_HEIGHT 95.0
#define EMPTY_HEIGHT 600.0

#define DEFAULT_HEIGHT 50.0

@interface FlightFormViewController ()

@property (nonatomic, assign) BOOL pickerOnDisplay;
@property (nonatomic, assign) BOOL currentPriceOnDisplay;
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic, assign) NSInteger currentPrice;

@end

@implementation FlightFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerOnDisplay = NO;
    self.currentPriceOnDisplay = YES;
    self.currentPrice = 120;
    self.currentDateString = @"14.06.2015";
    self.title = @"Booking";
}


#pragma mark - Refresh current price

- (void)generateNewPrice
{
    NSInteger seconds = 2;
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(updatePrice) userInfo:nil repeats:NO];
}

- (void)updatePrice
{
    NSInteger step = (NSInteger)rand() % 20;
    BOOL positive = (rand() % 11) > 5;
    self.currentPrice = positive ? self.currentPrice + step : self.currentPrice - step;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:PRICE_INDEX inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.refreshControl endRefreshing];
}


#pragma mark - Date picker cell delegate

- (void)datePickerCell:(DatePickerCell *)datePickerCell didUpdateCurrentDate:(NSString *)currentDateString
{
    NSLog(@"Update current date string: %@", currentDateString);
    self.currentDateString = currentDateString;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == DATE_INDEX) {
        self.pickerOnDisplay = !self.pickerOnDisplay;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.pickerOnDisplay) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    else if (indexPath.row == HEADER_INDEX) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (indexPath.row == PRICE_INDEX) {
        self.currentPriceOnDisplay = !self.currentPriceOnDisplay;
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:!self.currentPriceOnDisplay ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:!self.currentPriceOnDisplay ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:CONFIRM_INDEX inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *HeaderCellId = @"HeaderCell";
    static NSString *StartCellId = @"StartCell";
    static NSString *DepartureCellId = @"DepartureCell";
    static NSString *DestinationCellId = @"DestinationCell";
    static NSString *FlightClassCellId = @"FlightClassCell";
    static NSString *DatePickerCellId = @"DatePickerCell";
    static NSString *ConfirmButtonCellId = @"ConfirmButtonCell";
    static NSString *MaxPriceCellId = @"MaxPriceCell";
    static NSString *CurrentPriceCellId = @"CurrentPriceCell";
    static NSString *EmptyCellId = @"EmptyCell";

    switch (indexPath.row) {
        case HEADER_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellId];
            break;
        case START_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:StartCellId];
            break;
        case DESTINATION_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:DestinationCellId];
            break;
        case FLIGHT_CLASS_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:FlightClassCellId];
            break;
        case PRICE_INDEX: {
            NSString *cellId = nil;
            if (self.currentPriceOnDisplay) {
                cellId = CurrentPriceCellId;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                NSString *currentPriceString = [NSString stringWithFormat:@"%ld,-", (long)self.currentPrice];
                ((CurrentPriceCell *)cell).currentPriceLabel.text = currentPriceString;
            }
            else {
                cellId = MaxPriceCellId;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            }
            break;
        }
        case DATE_INDEX: {
            NSString *cellId = nil;
            if (self.pickerOnDisplay) {
                cellId = DatePickerCellId;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                ((DatePickerCell*)cell).delegate = self;
            }
            else {
                cellId = DepartureCellId;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                ((DepartureCell*)cell).dateLabel.text = self.currentDateString;
            }
            break;
        }
        case CONFIRM_INDEX: {
            NSString *buttonTitle = self.currentPriceOnDisplay ? @"Buy now" : @"Submit order";
            cell = [tableView dequeueReusableCellWithIdentifier:ConfirmButtonCellId];
            [((ConfirmButtonCell *)cell) setButtonTitle:buttonTitle];
            break;
        }
        case EMPTY_INDEX:
            cell = [tableView dequeueReusableCellWithIdentifier:EmptyCellId];
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (indexPath.row) {
        case HEADER_INDEX:
            height = HEADER_HEIGHT;
            break;
        case DATE_INDEX: {
            height = self.pickerOnDisplay ? DATE_PICKER_HEIGHT : DEFAULT_HEIGHT;
            break;
        }
        case CONFIRM_INDEX:
            height = CONFIRM_BUTTON_HEIGHT;
            break;
        case PRICE_INDEX:
            height = PRICE_HEIGHT;
            break;
        case EMPTY_INDEX:
            height = EMPTY_HEIGHT;
            break;
        default:
            height = DEFAULT_HEIGHT;
            break;
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ROWS;
}


@end
