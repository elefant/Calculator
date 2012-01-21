//
//  CalculatorBrain.m
//  Calculator
//
//  Created by bird on 12/1/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray* operandStack;
@property (nonatomic, strong) NSMutableArray* operatorStack;

- (double) performOperation:(NSString*)aOperator;

- (double) performBinaryOperation:(NSString*)aOperator;

- (double) performUniaryOperation:(NSString*)aOperator;

- (int) getOperatorPrecedence:(NSString*)aOpeator;

- (BOOL) isBinaryOperator:(NSString*)aOperator;

- (BOOL) isUniaryOperator:(NSString*)aOperator;

enum
{
    PRECEDENCE_UNKNOWN,
    
    PRECEDENCE_ADD,
    PRECEDENCE_SUBTRACT = PRECEDENCE_ADD,
    PRECEDENCE_EQUAL = PRECEDENCE_ADD,
    
    PRECEDENCE_MULTIPLY,
    PRECEDENCE_DIVIDE = PRECEDENCE_MULTIPLY,
};

@end

@implementation CalculatorBrain

@synthesize operandStack = mOperandStack;
@synthesize operatorStack = mOperatorStack;

- (NSMutableArray*)operandStack
{
    if( nil == mOperandStack )
    {
        mOperandStack = [[NSMutableArray alloc] init];
    }
    
    return mOperandStack;
}

- (NSMutableArray*)operatorStack
{
    if( nil == mOperatorStack )
    {
        mOperatorStack = [[NSMutableArray alloc] init];
    }
    
    return mOperatorStack;
}


- (void)pushOperand:(NSString *)operand
{
    NSNumber* newOperand = [[NSNumber alloc]initWithDouble:[operand doubleValue]];
    [self.operandStack addObject:newOperand];
}

- (BOOL)pushOperator:(NSString*) aOperator
        operationResult:(double*) aResult
{
    BOOL operationPerformed = NO;
    
    if( 0 == [[self operandStack] count] )
    {
        // something wrong
    }
    else if( 1 == [[self operandStack] count] )
    {
        if( [self isUniaryOperator:aOperator] )
        {
            *aResult = [self performUniaryOperation:aOperator];
            [self.operatorStack removeLastObject];
            operationPerformed = YES;
        }
        else
        {
            // simply push the operator to the stack
            [self.operatorStack addObject:aOperator];
        }
    }
    else // at least two operands
    {
        if( self.operatorStack.count > 0 )
        {
            NSString* lastOperator = [self.operatorStack lastObject];
            
            if( [self getOperatorPrecedence:aOperator] <= [self getOperatorPrecedence:lastOperator] )
            {
                [self.operatorStack removeLastObject];;
                
                *aResult = [self performOperation:lastOperator];
                operationPerformed = YES;
                
                [self pushOperator:aOperator operationResult:aResult];
            }
            else
            {
                [self.operatorStack addObject:aOperator];
            }
        }
        else
        {
            // something wrong
        }
    }
    
    return operationPerformed;
}

- (BOOL) isBinaryOperator:(NSString*)aOperator
{
    if( [@"=" isEqualToString:aOperator] )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL) isUniaryOperator:(NSString*)aOperator
{
    if( [@"=" isEqualToString:aOperator] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (double) performOperation:(NSString*)aOperator
{
    if( [self isUniaryOperator:aOperator] )
    {
        return [self performUniaryOperation:aOperator];
    }
    else if( [self isBinaryOperator:aOperator] )
    {
        return [self performBinaryOperation:aOperator];
    }
    else
    {
        // unsupported operator
        return 0;
    }
}

- (double) performUniaryOperation:(NSString*)aOperator
{
    double result = 0;
    
    // pop the operand to perform the uniary operation
    NSNumber* operand = [self.operandStack lastObject];
    [self.operandStack removeLastObject];
    
    if( [@"=" isEqualToString:aOperator] )
    {
        result = [operand doubleValue];
    }
    else
    {
        // unsupported uniary operator
    }
    
    return result;
}

- (double) performBinaryOperation:(NSString*)aOperator
{
    NSNumber* right = self.operandStack.lastObject;
    [self.operandStack removeLastObject];
    
    NSNumber* left = self.operandStack.lastObject;
    [self.operandStack removeLastObject];
    
    double result;
    if( [@"+" isEqualToString:aOperator] )
    {
        result = left.doubleValue + right.doubleValue;
    }
    else if( [@"-" isEqualToString:aOperator] )
    {
        result = left.doubleValue - right.doubleValue;
    }
    else if( [@"*" isEqualToString:aOperator] )
    {
        result = left.doubleValue * right.doubleValue;
    }
    else if( [@"/" isEqualToString:aOperator] )
    {
        result = left.doubleValue / right.doubleValue;
    }
    else
    {
        // usupported binary operator
    }
    
    NSNumber* resultNumber = [[NSNumber alloc]initWithDouble: result];
    [self.operandStack addObject:resultNumber];
    
    return result;
}

- (int) getOperatorPrecedence:(NSString*)aOpeator
{
    int precedence = PRECEDENCE_UNKNOWN;
    
    if( [@"*" isEqualToString:aOpeator] )
    {
        precedence = PRECEDENCE_MULTIPLY;
    }
    else if( [@"/" isEqualToString:aOpeator] )
    {
        precedence = PRECEDENCE_DIVIDE;
    }
    else if( [@"+" isEqualToString:aOpeator] )
    {
        precedence = PRECEDENCE_ADD;
    }
    else if( [@"-" isEqualToString:aOpeator] )
    {
        precedence = PRECEDENCE_SUBTRACT;
    }
    else if( [@"=" isEqualToString:aOpeator] )
    {
        precedence = PRECEDENCE_EQUAL;
    }
    
    return precedence;
}


@end
