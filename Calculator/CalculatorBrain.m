//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Alykhan Kanji on 18/06/12.
//  Copyright (c) 2012 Alykhan Kanji. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(id)program
{
	return [self.programStack mutableCopy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
	return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
	[self.programStack addObject:operation];
	return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
	double result = 0;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject];
    
	if ([topOfStack isKindOfClass:[NSNumber class]])
	{
		result = [topOfStack doubleValue];
	}
	else if ([topOfStack isKindOfClass:[NSString class]]) {
		NSString *operation = topOfStack;
		if ([operation isEqualToString:@"+"]) {
			result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
		} else if ([@"*" isEqualToString:operation]) {
			result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
		} else if ([operation isEqualToString:@"-"]) {
			double subtrahend = [self popOperandOffProgramStack:stack];
			result = [self popOperandOffProgramStack:stack] - subtrahend;
		} else if ([operation isEqualToString:@"/"]) {
			double divisor = [self popOperandOffProgramStack:stack];
			if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
		} else if ([operation isEqualToString:@"sin"]) {
			result = sin([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"cos"]) {
			result = cos([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"sqrt"]) {
			result = sqrt([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"log"]) {
			result = log10([self popOperandOffProgramStack:stack]);
		} else if ([operation isEqualToString:@"π"]) {
			result = M_PI;
		} else if ([operation isEqualToString:@"e"]) {
			result = M_E;
		} else if ([operation isEqualToString:@"switchSign"]) {
			result = -[self popOperandOffProgramStack:stack];
		}
	}
    
    return result;
}

+ (double)runProgram:(id)program
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	return [self popOperandOffProgramStack:stack];
}

- (void)performClear {
    [self.programStack removeAllObjects];
}

@end