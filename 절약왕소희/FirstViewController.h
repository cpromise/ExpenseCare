//
//  FirstViewController.h
//  절약왕소희
//
//  Created by SH on 2015. 8. 29..
//  Copyright (c) 2015년 SH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseScrollView.h"

@interface FirstViewController : UIViewController

//금액 표시 라벨
@property (weak, nonatomic) IBOutlet UILabel *lbGoalExpense;
@property (weak, nonatomic) IBOutlet UILabel *currentExpense;
@property (weak, nonatomic) IBOutlet UILabel *availableExpense;

//사용금액 입력 관련
- (IBAction)addMoney:(id)sender;
- (IBAction)saveExpense:(id)sender;
- (IBAction)initMoneyInput:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfExpenseObject;
@property (weak, nonatomic) IBOutlet UITextField *tfExpense;
@property NSMutableArray* expenseList;

//UI관련
@property (weak, nonatomic) IBOutlet ExpenseScrollView *scrollView;

- (NSDictionary *)getExpenseData;

@end

