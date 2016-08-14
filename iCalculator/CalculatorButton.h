//
//  CalculatorButton.h
//  iCalculator
//
//  Created by Bui Duc Khanh on 8/11/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum calculatorState
{
    VARIABLE_1,
    VARIABLE_2,
    RESULT
    
} CALCULATOR_STATE;

@interface CalculatorButton : UIButton

@property char value;

- (void)initializeButtonWithVal: (char)val isLight:(bool)isLight;

@end
