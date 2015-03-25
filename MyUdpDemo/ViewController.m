//
//  ViewController.m
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-10, 40)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:26];
    [titleLabel setText:@"UDP Server Host Setting"];
    titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    
    [self.view addSubview:titleLabel];
    
    UILabel *hostLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 40)];
    [hostLabel setText:@"Host:"];
    [hostLabel setShadowColor:[UIColor grayColor]];
    [self.view addSubview:hostLabel];
    
    self.hostField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 40)];
    [self.hostField setPlaceholder:@"enter host"];
    [self.hostField setBorderStyle:UITextBorderStyleBezel];
    [self.hostField.layer setCornerRadius:10];
    self.hostField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.view addSubview:self.hostField];
    
    UILabel *portLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, self.view.bounds.size.width - 40, 40)];
    [portLabel setText:@"Port:"];
    [portLabel setShadowColor:[UIColor grayColor]];
    [self.view addSubview:portLabel];
    
    self.portField = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, self.view.bounds.size.width - 240, 40)];
    [self.portField setPlaceholder:@"enter Port"];
    [self.portField setBorderStyle:UITextBorderStyleBezel];
    [self.portField.layer setCornerRadius:10];
    self.portField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:self.portField];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 370, self.view.bounds.size.width - 40, 40)];
    [saveButton setBackgroundColor:[UIColor lightGrayColor]];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    self.hostField.text = self.setting.host;
    self.portField.text = [self.setting.port stringValue];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.hostField.text = self.setting.host;
    self.portField.text = [self.setting.port stringValue];
}

-(IBAction)saveSetting:(id)sender{
    self.setting.host = self.hostField.text;
    self.setting.port = [[NSNumberFormatter alloc] numberFromString:self.portField.text];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
