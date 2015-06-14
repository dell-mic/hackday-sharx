//
//  ConfirmButtonCell.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "ConfirmButtonCell.h"

@interface ConfirmButtonCell()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation ConfirmButtonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"configure confirm button");
    self.confirmButton.layer.borderWidth  = 1.0;
    self.confirmButton.layer.borderColor = self.tintColor.CGColor;
}


- (void)setButtonTitle:(NSString *)buttonTitle
{
    [self.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.confirmButton setTitle:buttonTitle forState:UIControlStateHighlighted];

}


@end
