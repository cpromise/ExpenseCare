//
//  ExpenseTableView.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 30..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "ExpenseTableView.h"

@interface ExpenseTableView ()

@property float minHeight;

@end

@implementation ExpenseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//reload될 때, 테이블뷰의 높이만 바꿔줍니다.
-(void)reloadData{
    [super reloadData];
}

@end
