//
//  CalculatorButton.m
//  iCalculator
//
//  Created by Bui Duc Khanh on 8/11/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "CalculatorButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalculatorButton


// Hàm khởi tạo GUI cho button
- (void)initializeButtonWithVal: (char)val isLight:(bool)isLight
{
    self.value = val;
    
    if (isLight)
    {
        self.backgroundColor = UIColorFromRGB(0xF78E11);
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = UIColorFromRGB(0xD5D6D8);
        self.titleLabel.textColor = UIColorFromRGB(0x57585A);
    }
    
    self.titleLabel.font = [UIFont systemFontOfSize:40];
    [[self layer] setBorderWidth:0.5f];
    [[self layer] setBorderColor:UIColorFromRGB(0x5E5F61).CGColor];
    
    if (val == '!')
    {
        [self setTitle:@"+/-" forState:UIControlStateNormal];
    }
    else
    {
        [self setTitle:[NSString stringWithFormat:@"%c", val] forState:UIControlStateNormal];
    }
}


@end
