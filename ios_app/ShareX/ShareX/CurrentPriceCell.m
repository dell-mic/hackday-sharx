//
//  CurrentPriceCell.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "CurrentPriceCell.h"

@interface CurrentPriceCell()

@property (nonatomic, assign) BOOL positiveChange;

@end

@implementation CurrentPriceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.currentPrice = 120;
    
    double seconds = 3.5;
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(updatePrice) userInfo:nil repeats:YES];
}


- (void)updatePrice
{
    NSInteger step = (NSInteger)rand() % 20;
    self.positiveChange = (rand() % 11) > 3;
    self.currentPrice = self.positiveChange ? self.currentPrice + step : self.currentPrice - step;
}

- (void)setCurrentPrice:(NSInteger)currentPrice
{
    _currentPrice = currentPrice;
    self.currentPriceLabel.clipsToBounds = YES;
    UIColor *newBackgroundColor = !self.positiveChange ? [UIColor colorWithRed:0.0/255.0 green:204.0/255.0 blue:5.0/255.0 alpha:1.0] : [UIColor redColor];
    self.currentPriceLabel.layer.cornerRadius = self.currentPriceLabel.frame.size.height/2.0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeBackgroundColorFromLabel) userInfo:nil repeats:NO];
    self.currentPriceLabel.backgroundColor = newBackgroundColor;
    self.currentPriceLabel.textColor = [UIColor whiteColor];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%ld,-", (long)self.currentPrice];
}

- (void)removeBackgroundColorFromLabel
{
    self.currentPriceLabel.backgroundColor = [UIColor clearColor];
    self.currentPriceLabel.textColor = [UIColor blackColor];
}


@end
