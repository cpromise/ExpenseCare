//
//  FirstViewController.m
//  절약왕소희
//
//  Created by SH on 2015. 8. 29..
//  Copyright (c) 2015년 SH. All rights reserved.
//

#import "FirstViewController.h"
#import "SetGoalExpenseViewController.h"
#import "ExpenseTableView.h"
#import "ExpenseTableViewCell.h"
#import "Util.h"
#import "UIColor+EC.h"
#import "UIAlertController+ExpenseAlertController.h"

#define DATE_FORM @"yy-MM-dd hh-mm"

@interface FirstViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UITabBarDelegate, UITabBarControllerDelegate> {
    NSString *dataFilePath;
}
@property ExpenseTableView *expenseTableView;
@end


@implementation FirstViewController{
    NSUInteger curInputExpense;
    NSUInteger goalExpenseVal;
    NSNumber *goalExpense;
    
    BOOL useMonthlyAlarm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    curInputExpense = 0;
    _expenseList = [[NSMutableArray alloc] init];
    
    //지출 입력 시 이벤트 발생
    [_tfExpense addTarget:self action:@selector(didChangedInputExpense:) forControlEvents:UIControlEventEditingChanged];

    //지출 히스토리 델리게이트 설정
    _expenseTableView = [[ExpenseTableView alloc] initWithFrame:CGRectMake(0, TABLE_START_POINT, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    [_scrollView addSubview:_expenseTableView];
    NSLog(@"Width of ScrollVIew : %f",_scrollView.frame.size.width);
    NSLog(@"Height of ScrollVIew : %f",_scrollView.frame.size.height);

    _expenseTableView.rowHeight = 70.0f;
    self.expenseTableView.delegate = self;
    self.expenseTableView.dataSource = self;
    _scrollView.delegate = self;
    self.tabBarController.delegate = self;
    
    [self.view bringSubviewToFront:_scrollView];
    _expenseTableView.scrollEnabled = NO;
    
    [self updateMonthlyAlarm];
    [self refreshExpenseData];
    
    [self saveLastExpenseData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 버튼터치 이벤트
// +만,천,백 버튼
- (IBAction)addMoney:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *costToAdd = [NSString stringWithFormat:@"%@",button.titleLabel.text];
    
    if ([costToAdd isEqualToString:@"+만"]) {
        curInputExpense = [Util removeComma:_tfExpense.text] + 10000;
    } else if ([costToAdd isEqualToString:@"+천"]){
        curInputExpense = [Util removeComma:_tfExpense.text] + 1000;
    } else if ([costToAdd isEqualToString:@"+백"]){
        curInputExpense = [Util removeComma:_tfExpense.text] + 100;
    } else{
    }
    
    _tfExpense.text = [NSString stringWithFormat:@"%lu",(unsigned long)curInputExpense];
    [self didChangedInputExpense:_tfExpense];
    
    
    //스크롤뷰 완성되면 삭제해야함
    if( [_tfExpense isFirstResponder] ){
        [_tfExpense resignFirstResponder];
    }
    else if( [_tfExpenseObject isFirstResponder]){
        [_tfExpenseObject resignFirstResponder];
    }
}

// 저장하기
- (IBAction)saveExpense:(id)sender {
    if (_tfExpense == nil || [_tfExpense.text isEqualToString:@""] || [_tfExpenseObject.text isEqualToString:@"0"] || _tfExpense.text.length == 0) {
        if (_tfExpenseObject == nil || [_tfExpenseObject.text isEqualToString:@""] || _tfExpenseObject.text.length == 0) {
            UIAlertController *alert = [UIAlertController shortAlert:@"이런이런" withMessage:@"사용금액 또는 사용목적 중 \n적어도 한 개는 입력해야 합니다."];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [_tfExpenseObject becomeFirstResponder];
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

            return;
        }
    }

    if (!_expenseList) {
        _expenseList = [[NSMutableArray alloc] init];
    }
    [_expenseList addObject:[self getExpenseData]];
//    [NSKeyedArchiver archiveRootObject:_expenseList toFile:dataFilePath];
    [Util setLocalData:_expenseList forKey:EXPENSE_HISTORY];
    [self refreshExpenseData];
        
    _tfExpense.text = @"";
    _tfExpenseObject.text = @"";

}

// X버튼
- (IBAction)initMoneyInput:(id)sender {
    _tfExpense.text = @"";
}

#pragma mark - 지출 값 텍스트필드의 문자열을 숫자로 변환
- (NSUInteger)checkCurInputExpense{
    NSUInteger rst = [_tfExpense.text integerValue];
    return rst;
}

#pragma mark - 데이터 아카이빙 관련
- (NSDictionary *)getExpenseData{
    NSDictionary *expenseData = [[NSDictionary alloc] initWithObjectsAndKeys:_tfExpenseObject.text,@"EXPENSE_OBJECT",self.getExpenseDate,@"EXPENSE_DATE",[NSString stringWithFormat:@"%li",(long)[Util removeComma:_tfExpense.text]],@"EXPENSE_AMOUNT", nil];
    return expenseData;
}

//현재 시간 리턴
- (NSString *)getExpenseDate{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:DATE_FORM];
    NSString *expenseDate = [date stringFromDate:[NSDate date]];
    
    return expenseDate;
}

#pragma mark - mark 데이터 셋팅 (핵심메소드)
- (void)refreshExpenseData{
    NSInteger totalExpenseAmount = 0;
    
    //아카이빙을 통해서 저장된 지출 데이터 가져옴
    if ([[Util getLocalData] objectForKey:EXPENSE_HISTORY]) {
        _expenseList = [[Util getLocalData] objectForKey:EXPENSE_HISTORY];
        
        //총 사용 금액 계산
        for (NSInteger idx = 0; idx<_expenseList.count; idx++) {
            totalExpenseAmount += [[[_expenseList objectAtIndex:idx] objectForKey:@"EXPENSE_AMOUNT"] intValue];
        }
    }
    
    //총 사용금액, 사용가능 금액 변경
    [self refreshGoalExpense];
    _currentExpense.text = [NSString stringWithFormat:@"%@원",[Util commaFormat:totalExpenseAmount]];
    _availableExpense.text = [NSString stringWithFormat:@"%@원", totalExpenseAmount<=goalExpense.integerValue ?[Util commaFormat:goalExpense.integerValue-totalExpenseAmount]:@"0"];


    
    //테이블뷰에 데이터 삽입
    [_expenseTableView reloadData];
    float tableViewHeight = _expenseTableView.rowHeight*[_expenseTableView numberOfRowsInSection:0];

    //테이블뷰 최소사이즈를 스크롤뷰보다 작지 않게 설정
    if (tableViewHeight < _scrollView.frame.size.height) {
        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        float tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        float naviBarHeight = self.navigationController.navigationBar.frame.size.height;
        tableViewHeight = self.view.frame.size.height - statusBarHeight - naviBarHeight - tabBarHeight;
        
    }

    _expenseTableView.frame = CGRectMake(_expenseTableView.frame.origin.x, _expenseTableView.frame.origin.y, _expenseTableView.frame.size.width, tableViewHeight);

    
    _scrollView.contentSize = CGSizeMake(_expenseTableView.frame.size.width, tableViewHeight + TABLE_START_POINT);
    [_scrollView setValidRect:CGRectMake(0,TABLE_START_POINT, _expenseTableView.frame.size.width, _expenseTableView.frame.size.height)];
    
    
    //달이 바뀌었을 경우
    if ([self didChangeMonth]) {
        [self updateMonthlyAlarm];
        //MontlyAlarm을 사용할 경우 목표금액 리셋 제안 Alert
        if (useMonthlyAlarm) {
            UIAlertController *alertMonthChanged = [UIAlertController shortAlert:@"벌써 한 달"
                                                                     withMessage:@"달이 변경되어 새로운 데이터가 로딩됩니다. 목표금액을 변경하시겠습니까?"];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           [alertMonthChanged dismissViewControllerAnimated:YES completion:nil];
                                                           SetGoalExpenseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"setGoalExpenseViewController"];
                                                           [self.navigationController pushViewController:controller animated:YES];
                                                       }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               [alertMonthChanged dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alertMonthChanged addAction:ok];
            [alertMonthChanged addAction:cancel];
            [self presentViewController:alertMonthChanged animated:YES completion:nil];
        }
    }
    
    NSLog(@"count of data : %lu",(unsigned long)_expenseList.count);
}


#pragma mark - 목표금액 재설정
- (void)refreshGoalExpense{
    // 목표금액 관련
    // 디폴트 목표금액은 40만원
    if ([[Util getLocalData] objectForKey:GOAL_EXPENSE]) {
        goalExpense = [[Util getLocalData] objectForKey:GOAL_EXPENSE];
    } else{
        goalExpense = [NSNumber numberWithInteger:DEFAULT_GOAL_EXPENSE];
        [Util setLocalData:goalExpense forKey:GOAL_EXPENSE];
    }

    _lbGoalExpense.text = [NSString stringWithFormat:@"%@원",[Util commaFormat:goalExpense.integerValue]];
}

#pragma mark - - 델리게이트
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *vc = (UINavigationController *)viewController;
    UIViewController *vc2 = [vc.viewControllers objectAtIndex:0];
    if ([vc2 isKindOfClass:[FirstViewController class]]) {
        [self refreshExpenseData];
    }
}

- (void)didChangedInputExpense:(UITextField *)textfield {
    NSInteger val = [Util removeComma:textfield.text];
    textfield.text = [Util commaFormat:val];
    NSLog(@"%@-%s called.",[self class],__FUNCTION__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //TO-DO
    //무한 스크롤 방지
}

//텍스트필드 외부 터치 시 키보드 감춤
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( [_tfExpense isFirstResponder] ){
        [_tfExpense resignFirstResponder];
    }
    else if( [_tfExpenseObject isFirstResponder]){
        [_tfExpenseObject resignFirstResponder];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [_expenseList removeObjectAtIndex:(_expenseList.count - indexPath.row - 1)];
        //        [NSKeyedArchiver archiveRootObject:_expenseList toFile:dataFilePath];
        [Util setLocalData:_expenseList forKey:EXPENSE_HISTORY];
        [self refreshExpenseData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _expenseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"expenseCell";

    NSMutableDictionary *cellData = [_expenseList objectAtIndex:_expenseList.count - indexPath.row - 1];
    ExpenseTableViewCell *cell = [_expenseTableView dequeueReusableCellWithIdentifier:cellName];
    
    if ( !cell ) {
        [_expenseTableView registerNib:[UINib nibWithNibName:@"ExpenseTableViewCell" bundle:nil]
                forCellReuseIdentifier:cellName];
        
        cell = [_expenseTableView dequeueReusableCellWithIdentifier:cellName];
    }
    
    NSString *expenseObject = [cellData objectForKey:@"EXPENSE_OBJECT"];
    NSString *expenseDate = [cellData objectForKey:@"EXPENSE_DATE"];
    NSString *expenseAmount = [cellData objectForKey:@"EXPENSE_AMOUNT"];
    
    cell.lbExpenseAmount.text = [Util commaFormat:expenseAmount.integerValue];
    cell.lbExpenseDate.text = expenseDate;
    cell.lbExpenseObject.text = expenseObject;
//    cell.backgroundColor = [UIColor colorWithHexString:@"FDBD33"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)didChangeMonth{
    BOOL changed = NO;
    
    if (_expenseList && _expenseList.count > 0) {
        NSString *strLatestDate = [[_expenseList objectAtIndex:_expenseList.count-1] objectForKey:@"EXPENSE_DATE"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DATE_FORM];
        NSDate *latestDate = [dateFormatter dateFromString:strLatestDate];
        
        [dateFormatter setDateFormat:@"MM"];
        NSUInteger latestMonth = [dateFormatter stringFromDate:latestDate].integerValue;
        NSUInteger thisMonth = [dateFormatter stringFromDate:[NSDate date]].integerValue;
        
        if (thisMonth != latestMonth) {
            changed = YES;
        }
    }
    return changed;
}

- (void)updateMonthlyAlarm{
    if ([[Util getLocalData] objectForKey:MONTHLY_ALARM_YN]) {
        useMonthlyAlarm = [[[Util getLocalData] objectForKey:MONTHLY_ALARM_YN] boolValue];
    } else{
        [Util setLocalData:@(NO) forKey:MONTHLY_ALARM_YN];
        useMonthlyAlarm = NO;
    }
}

//달이 바뀌었는데, 지난 달의 지출정보가 있다면 해당 달에 해당하는 키로 지출정보를 저장한다.
//EXPENSE_HISTORY파일명에 저장되는 지출정보는 이번 달 내용으로 새롭게 채워나가야 한다.
//1달에 최대 1번만 실행되어야 하는 메소드
- (void)saveLastExpenseData{
    NSInteger prevYear = 0;
    NSInteger prevMonth = 0;
    NSString *prevExpense = nil;
    
    if (_expenseList && _expenseList.count > 0) {
        NSString *prevDate = [[_expenseList objectAtIndex:0] objectForKey:@"EXPENSE_DATE"];
        prevYear = [prevDate substringWithRange:NSMakeRange(0, 2)].integerValue;
        prevMonth = [prevDate substringWithRange:NSMakeRange(3, 2)].integerValue;
        prevExpense = [NSString stringWithFormat:EXPENSE_HISTORY_FILENAME_FORMAT,prevYear,prevMonth];

        //위험하니까 일단 블락처리..
//        [Util setLocalData:_expenseList forKey:prevExpense];
//        [Util setLocalData:nil forKey:EXPENSE_HISTORY];
    }
}

@end

