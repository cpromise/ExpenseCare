//
//  UIAlertController+ExpenseAlertController.m
//  절약왕소희
//
//  Created by SH on 2015. 10. 23..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "UIAlertController+ExpenseAlertController.h"

@implementation UIAlertController (ExpenseAlertController)

+ (UIAlertController *)shortAlert:(NSString *)title withMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

+ (UIAlertController *)shortAlert:(NSString *)title withMessage:(NSString *)message withOKButtonTitle:(NSString *)okTitle withAction:( void ( ^ ) (void))predicate withCancelButtonTitle:(NSString *)cancelTitle{
    UIAlertController *alert = [self shortAlert:title withMessage:message];
    
    if ( okTitle != nil && ![okTitle isEqualToString:@""] && okTitle.length > 0) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:predicate];
        }];
        [alert addAction:ok];
    }
    
    if ( cancelTitle != nil && ![cancelTitle isEqualToString:@""] && cancelTitle.length > 0) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
    }
    
    return alert;
}

@end
