//
//  SecondViewController.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 29..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "SecondViewController.h"
#import "Util.h"

@interface SecondViewController ()

@end

@implementation SecondViewController{
    BOOL useMonthlyAlarm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[Util getLocalData] objectForKey:MONTHLY_ALARM_YN]) {
        useMonthlyAlarm = [[[Util getLocalData] objectForKey:MONTHLY_ALARM_YN] boolValue];
    } else{
        useMonthlyAlarm = NO;
        [Util setLocalData:@NO forKey:MONTHLY_ALARM_YN];
    }
    [_switchMonthlyAlarm setOn:useMonthlyAlarm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTouchedMonthlyAlertAgree:(id)sender {
    UISwitch *swMonthlyAlertAgree = (UISwitch *)sender;

    if ([swMonthlyAlertAgree isOn]) {
        [Util setLocalData:@YES forKey:MONTHLY_ALARM_YN];
    } else{
        [Util setLocalData:@NO forKey:MONTHLY_ALARM_YN];
    }
}
@end
