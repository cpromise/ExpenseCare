//
//  SecondViewController.h
//  절약왕소희
//
//  Created by SH on 2015. 9. 29..
//  Copyright © 2015년 SH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UITableViewController
- (IBAction)onTouchedMonthlyAlertAgree:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchMonthlyAlarm;

@end
