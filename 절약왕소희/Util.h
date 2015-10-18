//
//  Util.h
//  절약왕소희
//
//  Created by SH on 2015. 9. 28..
//  Copyright © 2015년 SH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TABLE_START_POINT 250
#define EXPENSE_HISTORY @"expenseHistory"
#define GOAL_EXPENSE @"goalExpense"
#define DEFAULT_GOAL_EXPENSE 400000

@interface Util : NSObject

@property NSDictionary *localData;

//숫자 문자열에 콤마 입력
+ (NSString *)commaFormat:(NSInteger)val;
+ (NSInteger)removeComma:(NSString *)formattedStr;

//앨럿창 하나 만들어서 리턴
+ (UIAlertController *)shortAlert:(NSString *)message;

//로컬데이터 아카이빙 관련
+ (NSMutableDictionary *)getLocalData;
+ (void)setLocalData:(NSObject *)data forKey:(NSString *)key;

@end
