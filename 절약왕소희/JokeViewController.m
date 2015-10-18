//
//  JokeViewController.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 29..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "JokeViewController.h"
#import "Util.h"
#import <MessageUI/MessageUI.h>

@interface JokeViewController () <MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>

    @property Util* util;
@end

@implementation JokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 문자메시지 전송
- (void)sendMessageWithVal:(NSString *)money{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"빠루에게  %@원 빌리기 찬스를 요청합니다.",money];
        controller.recipients = [NSArray arrayWithObjects:@"01045461620", nil];
        controller.messageComposeDelegate = self;
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cacelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"failed");
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma 이벤트(Joke) 버튼 터치 이벤트
-(IBAction)onTouchedChance:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == 0) {
        NSLog(@"빌리기 찬스");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"빌리기 찬스"
                                      message:@"얼마를 빌리시겠어요?"
                                      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       UITextField *tmp = alert.textFields.firstObject;
                                                       __block NSString *moneyToRequest = nil;
                                                       if (tmp.text.length > 0 && tmp.text != nil && [tmp.text isEqualToString:@""] == FALSE) {
                                                           moneyToRequest = tmp.text;
                                                       } else{
                                                           moneyToRequest = @"0";
                                                       }

                                                       [self sendMessageWithVal:moneyToRequest];
                                                   }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            [textField addTarget:self action:@selector(didChangedInputExpense:) forControlEvents:UIControlEventEditingChanged];
            textField.placeholder = @"빠루의 눈물";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:btn.titleLabel.text
                                      message:@"지원되지 않는 기능입니다."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma 델리게이트 및 유틸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if( [_tfRequestMoney isFirstResponder] ){
    //        [_tfRequestMoney resignFirstResponder];
    //    }
    //    else if( [_tfRequestMoney isFirstResponder]){
    //        [_tfRequestMoney resignFirstResponder];
    //    }
}

- (void)didChangedInputExpense:(UITextField *)textfield {
    NSInteger val = [Util removeComma:textfield.text];
    textfield.text = [Util commaFormat:val];
    NSLog(@"%@-%s called.",[self class],__FUNCTION__);
}

@end
