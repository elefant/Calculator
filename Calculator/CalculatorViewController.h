//
//  CalculatorViewController.h
//  Calculator
//
//  Created by bird on 12/1/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
- (IBAction)onPressed:(id)sender;
- (IBAction)onOperatorPressed:(UIButton*)sender;

@end
