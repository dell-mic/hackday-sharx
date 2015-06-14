//
//  ConfirmButtonCell.h
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConfirmButtonCell;

@protocol ConfirmButtonCellDelegate <NSObject>

- (void)didPressConfirmButton;

@end

@interface ConfirmButtonCell : UITableViewCell

- (void)setButtonTitle:(NSString *)buttonTitle;

@property (nonatomic, strong) id<ConfirmButtonCellDelegate> delegate;

@end
