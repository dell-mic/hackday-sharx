//
//  PriceDetailCell.h
//  ShareX
//
//  Created by Nikolas Burk on 14/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDifferenceLabel;

@property (nonatomic, assign) NSInteger currentPrice;
@property (nonatomic, assign) BOOL positiveChange;

@end
