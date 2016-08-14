//
//  ViewController.m
//  iCalculator
//
//  Created by Bui Duc Khanh on 8/10/16.
//  Copyright © 2016 Bui Duc Khanh. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorButton.h"


@interface ViewController ()

@end

@implementation ViewController
{
    UILabel* lblFormula;
    UILabel* lblResult;
    
    NSMutableArray * arrBtn;
    
    CALCULATOR_STATE state;
    
    NSString* variableString1;
    double variable1;
    NSString* variableString2;
    double variable2;
    
    NSString* resultString;
    double result;
    
    char operator;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Gọi hàm dựng giao diện
    [self buildGUI];
    
    // Reset calculator
    [self reset];
}


// Hàm điều hướng chung
- (void) onButtonClick: (CalculatorButton*) sender{
    char op = sender.value;
    
    switch (op)
    {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '.':
        case '!':
            [self setVariable:op];
            break;
            
        case '+':
        case '-':
        case '*':
        case ':':
        case '%':
            [self setOperator:op];
            break;
            
        case 'C':
            [self reset];
            break;
            
        case '=':
            [self calculate];
            break;
    }
}


// Gán các biến
- (void) setVariable: (char) val{
    if (state == RESULT)
        [self reset];

    
    NSString *variable = variableString1;
    if (state == VARIABLE_2)
        variable = variableString2;
    
    
    if (val == '!') // đổi dấu
    {
        if (variable.length > 0 && [variable characterAtIndex:0] == '-')
        {
            variable = [variable substringFromIndex:1];
        }
        else
        {
            variable = [NSString stringWithFormat:@"-%@", variable];
        }
    }
    else if (val == '.') // Hàm thập phân
    {
        if (variable.length == 0)
        {
            variable = @"0.";
        }
        else if ([variable rangeOfString:@"."].location == NSNotFound)
        {
            variable = [NSString stringWithFormat:@"%@.", variable];
        }
    }
    else if (val == '0')
    {
        if (!(variable.length == 1 && [variable characterAtIndex:0] == '0'))
        {
            variable = [NSString stringWithFormat:@"%@%c", variable, val];
        }
    }
    else
    {
        if (variable.length == 1 && [variable characterAtIndex:0] == '0')
        {
            variable = [NSString stringWithFormat:@"%c", val];
        }
        else
            variable = [NSString stringWithFormat:@"%@%c", variable, val];
    }
    
    // Trả lại kết quả vào biến
    double valValue = 0;
    if (![variableString1 isEqualToString:@"-"])
        valValue =[variable doubleValue];
        
    if (state == VARIABLE_1)
    {
        variableString1 = variable;
        variable1 = valValue;
    }
    else
    {
        variableString2 = variable;
        variable2 = valValue;
    }
    
    [self display];
}


// Thiết lập toán tử
- (void) setOperator: (char) val{
    
    // Nếu chưa có thiết lập gì variableString2 thì bỏ qua, nếu đã có tính kết quả
    if(state == VARIABLE_2 && variableString2.length > 0)
    {
        [self calculate]; // Hàm này sẽ chuyển state == RESULT
    }
    
    // Nếu đang hiển thị kết quả -> gán kết quả vào biến 1
    if(state == RESULT)
    {
        variableString1 = resultString;
        variable1 = result;
        
        variableString2 = @"";
        variable2 = 0;
        
        resultString = @"";
        result = 0;
    }
    
    // Gán toán tử và chuyển trạng thái
    state = VARIABLE_2;
    operator = val;
    
    [self display];
}


// Khởi tạo lại máy tính
- (void) reset{
    variableString1 = @"";
    variable1 = 0;
    
    variableString2 = @"";
    variable2 = 0;
    
    resultString = @"";
    result = 0;
    
    operator = '0';
    
    state = VARIABLE_1;
    
    [self display];
}


// Hàm tính kết quả
- (void) calculate{
    // Kiểm tra lỗi division by zero
    if ((operator == ':' || operator == '%') && variable2 == 0)
    {
        [self reset];
        
        lblResult.text = @"DIVISION BY ZERO";
    }
    else
    {
        switch(operator)
        {
            case '-': result = variable1 - variable2; break;
            case '*': result = variable1 * variable2; break;
            case ':': result = variable1 / variable2; break;
            case '%': result = variable1 *100.0 / variable2; break;
            default:  result = variable1 + variable2;
                
        }
        
        resultString = [NSString stringWithFormat:@"%.15g", result];
        
        state = RESULT;
        [self display];
    }
}

// Hiển thị kết quả
- (void) display{
    lblFormula.text = @"";
    lblResult.text = @"";
    
    NSString* valText1 = [self formatNumberString:variableString1];
    if (variable1 < 0)
        valText1 = [NSString stringWithFormat:@"(%@)", valText1];
    
    NSString* valText2 = [self formatNumberString:variableString2];
    if (variable2 < 0)
        valText2 = [NSString stringWithFormat:@"(%@)", valText2];
    
    NSString* op = @"";
    if (operator != '0')
        op = [NSString stringWithFormat:@"%c", operator];
    
    lblFormula.text = [NSString stringWithFormat:@"%@%@%@", valText1, op, valText2];
    lblResult.text = [self formatNumberString:resultString];
}


// Hiển thị kết quả bổ sung dấu , phân cách hàng nghìn cho đẹp
- (NSString*) formatNumberString: (NSString *)number{
    if (number.length <= 3)
        return number;
    
    NSRange range = [number rangeOfString:@"."];
    NSString* decimal;
    NSString* precision;
    
    if (range.location == NSNotFound)
    {
        decimal = number;
        precision = @"";
    }
    else
    {
        decimal = [number substringToIndex:range.location];
        precision = [number substringFromIndex:range.location];
    }
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formattedDecimal = [formatter stringFromNumber:[NSNumber numberWithInteger:[decimal intValue]]];
    
    return [NSString stringWithFormat:@"%@%@", formattedDecimal, precision];
}


// Hàm vẽ giao diện calculator
- (void) buildGUI{
    float y = 0;
    float formulaFont= 17;
    float resultFont=40;
    float formulaHeight= 40;
    float resultHeight=80;
    
    // Kích thước nút (tạo nút vuông)
    float size = self.view.bounds.size.width/4.0;
    
    if ((self.view.bounds.size.height - size * 5.0) < 120) // Iphone 4s
    {
        y = 10;
        formulaHeight = (self.view.bounds.size.height - size * 5.0)/3.0;
        resultHeight = (self.view.bounds.size.height - size * 5.0) * 2.0/3.0;
        
        formulaFont= 17;
        resultFont=40;
    }
    else
    {
        y = 30;
        formulaHeight = (self.view.bounds.size.height - size * 5.0 - 30)/3.0;
        resultHeight = (self.view.bounds.size.height - size * 5.0 - 30) * 2.0/3.0;
    }
        
    
    // Tạo nền
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // Label hiển thị công thức tính toán
    lblFormula = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, formulaHeight)];
    lblFormula.textColor = [UIColor whiteColor];
    /*
    lblFormula.numberOfLines = 1;
    lblFormula.minimumScaleFactor = formulaFont/lblResult.font.pointSize;
    lblFormula.adjustsFontSizeToFitWidth = YES;
     */
    NSLog(@"%f", formulaFont);
    lblFormula.font = [UIFont systemFontOfSize:formulaFont];
    lblFormula.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lblFormula];
    
    // Label hiển thị kết quả
    y = lblFormula.frame.origin.y+ lblFormula.frame.size.height;
    lblResult = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, resultHeight)];
    lblResult.textColor = [UIColor whiteColor];
    NSLog(@"%f", resultFont);
    lblResult.font = [UIFont systemFontOfSize:resultFont];
    lblResult.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lblResult];

    // Mảng chứa các nút bấm
    arrBtn = [[NSMutableArray alloc] init];
    
    
    // Biến tạm chứa nút bấm
    CalculatorButton * btn;
    
    // Tạo các nút hàng 1
    y = lblResult.frame.origin.y + lblResult.frame.size.height; // Toạ độ vùng nút bấm hàng 1
    
    // Phím C
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(0, y, size, size)];
    [btn initializeButtonWithVal:'C' isLight:false];
    [arrBtn addObject:btn];
    
    // Phím đổi dấu
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(size, y, size, size)];
    [btn initializeButtonWithVal:'!' isLight:false];
    [arrBtn addObject:btn];
    
    // Phím %
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(2*size, y, size, size)];
    [btn initializeButtonWithVal:'%' isLight:false];
    [arrBtn addObject:btn];
    
    // Phím :
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(3*size, y, size, size)];
    [btn initializeButtonWithVal:':' isLight:true];
    [arrBtn addObject:btn];
    
    // Các phím số
    float xAxis = 2*size;
    float yAxis = y + size;
    for (char c='9'; c > '0'; c--)
    {
        btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(xAxis, yAxis, size, size)];
        [btn initializeButtonWithVal:c isLight:false];
        [arrBtn addObject:btn];
        
        xAxis = xAxis - size;
        if (xAxis < 0)
        {
            xAxis = 2*size;
            yAxis = yAxis + size;
        }
    }
    
    // Hàng 2 phím *
    y = y + size;
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(3*size, y, size, size)];
    [btn initializeButtonWithVal:'*' isLight:true];
    [arrBtn addObject:btn];
    
    // Hàng 3 phím -
    y = y + size;
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(3*size, y, size, size)];
    [btn initializeButtonWithVal:'-' isLight:true];
    [arrBtn addObject:btn];
    
    // Hàng 4 phím +
    y = y + size;
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(3*size, y, size, size)];
    [btn initializeButtonWithVal:'+' isLight:true];
    [arrBtn addObject:btn];
    
    // Hàng 5 phím =
    y = y + size;
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(3*size, y, size, size)];
    [btn initializeButtonWithVal:'=' isLight:true];
    [arrBtn addObject:btn];
    
    // Hàng 5 phím .
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(2*size, y, size, size)];
    [btn initializeButtonWithVal:'.' isLight:false];
    [arrBtn addObject:btn];
    
    // Hàng 5 phím 0
    btn = [[CalculatorButton alloc] initWithFrame:CGRectMake(0, y, 2*size, size)];
    [btn initializeButtonWithVal:'0' isLight:false];
    [arrBtn addObject:btn];
    
    // Xử lý các nút
    for (CalculatorButton *item in arrBtn) {
        // Đưa vào giao diện
        [self.view addSubview:item];
        
        // Gắn sự kiện
        [item addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
