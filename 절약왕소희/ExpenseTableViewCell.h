//
//  ExpenseTableViewCell.h
//  절약왕소희
//
//  Created by SH on 2015. 9. 8..
//  Copyright (c) 2015년 SH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbExpenseObject;
@property (weak, nonatomic) IBOutlet UILabel *lbExpenseDate;
@property (weak, nonatomic) IBOutlet UILabel *lbExpenseAmount;

@end
