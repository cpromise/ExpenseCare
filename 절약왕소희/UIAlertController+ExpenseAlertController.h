//
//  UIAlertController+ExpenseAlertController.h
//  절약왕소희
//
//  Created by SH on 2015. 10. 23..
//  Copyright © 2015년 SH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ExpenseAlertController)

+ (UIAlertController *)shortAlert:(NSString *)title withMessage:(NSString *)message;
+ (UIAlertController *)shortAlert:(NSString *)title withMessage:(NSString *)message withOKButtonTitle:(NSString *)okTitle withAction:( void ( ^ ) (void))predicate withCancelButtonTitle:(NSString *)cancelTitle;

@end
