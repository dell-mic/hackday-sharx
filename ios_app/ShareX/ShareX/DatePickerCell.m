//
//  DatePickerCell.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "DatePickerCell.h"

@interface DatePickerCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end


@implementation DatePickerCell

- (void)awakeFromNib
{

}

- (IBAction)dateChanged:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormat stringFromDate:sender.date];
    NSLog(@"date: %@", dateString);
    self.dateLabel.text = dateString;

    if ([self.delegate respondsToSelector:@selector(datePickerCell:didUpdateCurrentDate:)]) {
        [self.delegate datePickerCell:self didUpdateCurrentDate:dateString];
    }
    
}


@end
