//
//  CurrentPriceCell.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentPriceCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentPrice;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;


@end
