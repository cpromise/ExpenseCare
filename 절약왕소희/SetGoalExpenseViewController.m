//
//  SetGoalExpenseViewController.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 29..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "SetGoalExpenseViewController.h"
#import "Util.h"
#import "UIAlertController+ExpenseAlertController.h"
#define ALERT_DISMISS_TIME 1.5

@interface SetGoalExpenseViewController ()

@end

@implementation SetGoalExpenseViewController{
    NSNumber *goalExpenseVal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    goalExpenseVal = [[Util getLocalData] objectForKey:GOAL_EXPENSE];
    _lbGoalExpense.text = [Util commaFormat:goalExpenseVal.integerValue];
    _tfGoalExpense.text = [Util commaFormat:goalExpenseVal.integerValue];
    [_tfGoalExpense addTarget:self action:@selector(didChangedInputExpense:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 목표 값 저장하기 버튼 터치 이벤트
- (IBAction)btnSetGoalExpense:(id)sender {
    NSNumber *goalExpenseToSave = [NSNumber numberWithInteger:[Util removeComma:_tfGoalExpense.text]];
    [Util setLocalData:goalExpenseToSave forKey:GOAL_EXPENSE];
    _lbGoalExpense.text = [Util commaFormat:goalExpenseToSave.integerValue];

    [self.tabBarController.delegate tabBarController:self.tabBarController didSelectViewController:[self.tabBarController.viewControllers objectAtIndex:0]];


    UIAlertController *alert = [UIAlertController shortAlert:@"변경 완료" withMessage:@"변경을 완료했습니다."];
    [self presentViewController:alert animated:NO completion:nil];
    
    //비동기처리를 안주어야함. 안해주면 탭 이동간의 UX가 구려짐
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ALERT_DISMISS_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
            [self.tabBarController setSelectedIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.navigationController popViewControllerAnimated:YES];
            });
        });

    });
}

#pragma mark - 편리한 금액변경 왕버튼 터치 이벤트
- (IBAction)addSetGoalExpense:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger addedVal = btn.tag * 10000;
    
    addedVal += [Util removeComma:_tfGoalExpense.text];
    _tfGoalExpense.text = [Util commaFormat:addedVal];
    _lbGoalExpense.text = [Util commaFormat:addedVal];
}

#pragma mark - 델리게이트 및 유틸
- (void)didChangedInputExpense:(UITextField *)textfield {
    NSInteger val = [Util removeComma:textfield.text];
    textfield.text = [Util commaFormat:val];
    NSLog(@"%@-%s called.",[self class],__FUNCTION__);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( [_tfGoalExpense isFirstResponder] ){
        [_tfGoalExpense resignFirstResponder];
    }
}

@end
