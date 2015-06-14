//
//  MaxPriceCell.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "MaxPriceCell.h"

@interface MaxPriceCell()



@end

@implementation MaxPriceCell



- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    NSInteger newValue = (NSInteger)sender.value;
    
    NSString *newMaxPriceString = [NSString stringWithFormat:@"%ld,-", (long)newValue];
//    NSString *newMaxPriceString = [NSString stringWithFormat:@"%ld", (long)newValue];
    self.maxPriceLabel.text = newMaxPriceString;
}

@end
