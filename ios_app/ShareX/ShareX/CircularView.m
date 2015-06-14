//
//  CircularView.m
//  ShareX
//
//  Created by Nikolas Burk on 13/06/15.
//  Copyright (c) 2015 Nikolas Burk. All rights reserved.
//

#import "CircularView.h"

@implementation CircularView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.height/2.0;
    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
