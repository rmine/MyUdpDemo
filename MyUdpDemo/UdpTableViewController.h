//
//  UdpTableViewController.h
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Msg.h"
#import "Setting.h"

@interface UdpTableViewController : UITableViewController <UITextViewDelegate>

@property (strong, nonatomic) UITextView *inputTextView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) NSMutableArray *msgArray;
@property (strong, nonatomic) Msg *msg;
@property (strong, nonatomic) Setting *setting;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *startStopButtonItem;
@property (strong, nonatomic) UIBarButtonItem *settingButtonItem;

- (void)sendMsg:(id)sender;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)refreshTableView:(Msg *) msg;
@end
