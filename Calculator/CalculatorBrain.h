//
//  CalculatorBrain.h
//  Calculator
//
//  Created by bird on 12/1/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(NSString*)aOperand;;

- (BOOL)pushOperator:(NSString*) aOperator
     operationResult:(double*) aResult;;;

@end
