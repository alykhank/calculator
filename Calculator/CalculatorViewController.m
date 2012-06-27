//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Alykhan Kanji on 18/06/12.
//  Copyright (c) 2012 Alykhan Kanji. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
//    NSLog(@"user touched %@", digit);
    
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
//    self.history.text = [self.history.text stringByAppendingString:digit];
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    
    self.history.text = [self.history.text stringByAppendingString:self.display.text];
    self.history.text = [self.history.text stringByAppendingString:@" "];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
    self.history.text = [self.history.text stringByAppendingString:@" ="];
}

- (IBAction)decimalPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound && self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else if (range.location == NSNotFound) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed {
    [self.brain performClear];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = @"";
}

- (IBAction)backspacePressed {
    if ([self.display.text length] > 1)
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    else if ([self.display.text length] == 1)
        self.display.text = @"0";
}

- (IBAction)signPressed {
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    
    NSRange range = [self.display.text rangeOfString:@"-"];
    if (self.userIsInTheMiddleOfEnteringANumber && range.location == NSNotFound) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    } else if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringFromIndex:1];
    } else {
        double result = [self.brain performOperation:@"switchSign"];
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
        self.display.text = resultString;
        self.history.text = [self.history.text stringByAppendingString:@"+/- ="];
    }
}
@end