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
+ (BOOL)isOperation:(NSString *)operation;
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

- (void)pushVariable:(NSString *)variable
{
	[self.programStack addObject:variable];
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
	else if ([topOfStack isKindOfClass:[NSString class]])
	{
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
	for (int i = 0; i < stack.count; i++)
	{
		id element = [stack objectAtIndex:i];
		if ([[[self class] variablesUsedInProgram:program] containsObject:element])
		{
			[stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
		}
	}
	return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	for (int i = 0; i < stack.count; i++)
	{
		id element = [stack objectAtIndex:i];
//		if ([element isKindOfClass:[NSString class]] && ![element isOperation:element])
		if ([[[self class] variablesUsedInProgram:program] containsObject:element])
		{
			NSNumber *variableValue = [variableValues objectForKey:element];
			// Replace variable with its value if it exists in the dictionary, else replace it with 0
			if (variableValue) [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:element]];
			else [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0]];
		}
	}
	return [self popOperandOffProgramStack:stack];
}

+ (BOOL)isOperation:(NSString *)operation
{
	NSSet *operations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"log", @"π", @"e", @"switchSign", nil];
	if ([operations containsObject:operation]) {
		return true;
	}
	return false;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
	NSMutableArray *variables = [[NSMutableArray alloc] init];
	for (id element in program)
	{
		if ([element isKindOfClass:[NSString class]] && ![[self class] isOperation:element])
		{
			[variables addObject:element];
		}
	}
	if ([variables count] == 0) return nil;
	return [NSSet setWithArray:variables];
}

- (void)performClear {
    [self.programStack removeAllObjects];
}

@end