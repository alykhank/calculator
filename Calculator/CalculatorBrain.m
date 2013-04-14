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
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(id)program
{
	return [self.programStack mutableCopy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
	NSMutableArray *stack;
	if ([program isKindOfClass:[NSArray class]]) {
		stack = [program mutableCopy];
	}
	NSMutableArray *programItems = [[NSMutableArray alloc] init];
	while ([stack count] > 0)
	{
		[programItems addObject:[self descriptionOfTopOfStack:stack]];
	}
	return [programItems componentsJoinedByString:@", "];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushOperation:(NSString *)operation
{
	[self.programStack addObject:operation];
}

- (double)performOperation:(NSString *)operation
{
	[self.programStack addObject:operation];
	return [[self class] runProgram:self.program];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
	NSString *result;
	
	id topOfStack = [stack lastObject];
	if (topOfStack) [stack removeLastObject];
    
	if ([topOfStack isKindOfClass:[NSNumber class]])
	{
		result = [NSString stringWithFormat:@"%@", topOfStack];
	}
	else if ([topOfStack isKindOfClass:[NSString class]])
	{
		NSString *operation = topOfStack;
		if ([[self class] numberOfOperandsRequired:operation] == 2)
		{
			NSString *firstOperand = [self descriptionOfTopOfStack:stack];
			NSString *secondOperand = [self descriptionOfTopOfStack:stack];
            if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) result = [NSString stringWithFormat:@"%@ %@ %@", secondOperand, operation, firstOperand];
            else result = [NSString stringWithFormat:@"(%@ %@ %@)", secondOperand, operation, firstOperand];
		}
		else if ([[self class] numberOfOperandsRequired:operation] == 1)
		{
			NSString *firstOperand = [self descriptionOfTopOfStack:stack];
			if ([operation isEqualToString:@"switchSign"])
            {
                if ([firstOperand rangeOfString:@"-"].location == 0 && [firstOperand rangeOfString:@"("].location == 1 && [firstOperand rangeOfString:@")" options:NSBackwardsSearch].location == [firstOperand length] - 1) result = [NSString stringWithFormat:@"%@", [[firstOperand substringFromIndex:2] substringToIndex:[firstOperand length] - 3]];
                else result = [NSString stringWithFormat:@"-(%@)", firstOperand];
            }
			else result = [NSString stringWithFormat:@"%@(%@)", operation, firstOperand];
		}
		else if ([[self class] numberOfOperandsRequired:operation] == 0)
		{
			result = [NSString stringWithFormat:@"%@", operation];
		}
	}
    else
    {
        result = [NSString stringWithFormat:@"0"];
    }
    
    return result;
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
	return [self runProgram:program usingVariableValues:nil];
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
	if ([operations containsObject:operation]) return true;
	return false;
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
	NSMutableArray *variables = [[NSMutableArray alloc] init];
	for (id element in program)
		if ([element isKindOfClass:[NSString class]] && ![[self class] isOperation:element]) [variables addObject:element];
	if ([variables count] == 0) return nil;
	return [NSSet setWithArray:variables];
}

+ (int)numberOfOperandsRequired:(NSString *)operation
{
	NSSet *twoOperandOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
	NSSet *oneOperandOperations = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", @"switchSign", nil];
	if ([twoOperandOperations containsObject:operation]) return 2;
	else if ([oneOperandOperations containsObject:operation]) return 1;
	else return 0;
}

- (void)performClear
{
    [self.programStack removeAllObjects];
}

- (void)popItem
{
    [self.programStack removeLastObject];
}

@end