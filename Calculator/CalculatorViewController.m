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

- (void)updateDisplay {
    // If history ends with "=", remove the sign
    if ([self.history.text hasSuffix:@" ="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length] - 1];
    }
    
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
	
    [self updateDisplay];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        if (![digit isEqualToString:@"0"]) {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
		else {
			self.display.text = digit;
		}
    }
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];

    [self updateDisplay];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    [self updateDisplay];
    self.history.text = [self.history.text stringByAppendingString:@" ="];
}

- (IBAction)decimalPressed {
	
    [self updateDisplay];
	
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        } else {
            self.display.text = @"0.";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)clearPressed {
    [self.brain performClear];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateDisplay];
}

- (IBAction)backspacePressed {
    if ([self.display.text length] > 1) {
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    } else if ([self.display.text length] == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)signPressed {
    
    NSRange range = [self.display.text rangeOfString:@"-"];
    if (self.userIsInTheMiddleOfEnteringANumber && range.location == NSNotFound) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    } else if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringFromIndex:1];
    } else {
        double result = [self.brain performOperation:@"switchSign"];
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
        self.display.text = resultString;
        [self updateDisplay];
        self.history.text = [self.history.text stringByAppendingString:@" ="];
    }
}
- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
    
    [self updateDisplay];
}

@end