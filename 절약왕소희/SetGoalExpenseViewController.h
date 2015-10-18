//
//  SetGoalExpenseViewController.h
//  절약왕소희
//
//  Created by SH on 2015. 9. 29..
//  Copyright © 2015년 SH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"

@interface SetGoalExpenseViewController : UIViewController

//UI관련
@property (weak, nonatomic) IBOutlet UITextField *lbGoalExpense;
@property (weak, nonatomic) IBOutlet UITextField *tfGoalExpense;
- (IBAction)btnSetGoalExpense:(id)sender;
- (IBAction)addSetGoalExpense:(id)sender;

@end
