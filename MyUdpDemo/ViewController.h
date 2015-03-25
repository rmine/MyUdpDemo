//
//  ViewController.h
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Setting *setting;
@property (strong, nonatomic) UITextField *hostField;
@property (strong, nonatomic) UITextField *portField;

@end

