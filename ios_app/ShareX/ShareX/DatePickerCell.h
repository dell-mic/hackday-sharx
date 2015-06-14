//
//  DatePickerCell.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerCell;

@protocol DatePickerCellDelegate <NSObject>

- (void)datePickerCell:(DatePickerCell *)datePickerCell didUpdateCurrentDate:(NSString *)currentDateString;


@end

@interface DatePickerCell : UITableViewCell

@property (nonatomic, weak) id<DatePickerCellDelegate> delegate;

@end
