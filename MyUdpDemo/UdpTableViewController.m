//
//  UdpTableViewController.m
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import "UdpTableViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "ViewController.h"

// Log levels: off, error, warn, info, verbose
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;

static float DEVICE_HEIGHT = 0;
static float DEVICE_WIDTH = 0;

@interface UdpTableViewController (){
    long tag;
    GCDAsyncUdpSocket *udpSocketClient;
    GCDAsyncUdpSocket *udpSocketServer;
    NSMutableString *log;
    
    BOOL isRunning;
}

@end

@implementation UdpTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        log = [[NSMutableString alloc] init];
        
        DEVICE_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
        DEVICE_WIDTH = [[UIScreen mainScreen] bounds].size.width;
        
        self.msgArray = [[NSMutableArray alloc] init];
        Msg *msg = [[Msg alloc] initWithMsg:@"First Message init." initWithCreated:[NSDate date]];
        [self.msgArray addObject:msg];
        
        self.setting = [[Setting alloc] initWithHost:@"192.168.44.11" initWithCreated:@8888];
    }
    return self;
}


-(void)setupSocket
{
    udpSocketClient = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    udpSocketServer = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![udpSocketClient bindToAddress:0 error:&error]) {
        NSLog(@"Error binding: %@",error);
        return;
    }
    if (![udpSocketClient beginReceiving:&error]) {
        NSLog(@"Error receiving: %@",error);
        return;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"UDP Demo"];
    
    
//    [self.tableView setFrame:CGRectMake(0,64+40,250,40)];
    
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.delegate = self;
    self.inputTextView.frame = CGRectMake(10,DEVICE_HEIGHT -(64+40),250,40);
    self.inputTextView.backgroundColor = [UIColor cyanColor];
    self.inputTextView.keyboardType = UIKeyboardTypeDefault;
    [self.inputTextView.layer setCornerRadius:10];
    [self.view addSubview:self.inputTextView];
    
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.frame = CGRectMake(15+250,[[UIScreen mainScreen] bounds].size.height -(40+44+20),DEVICE_WIDTH -275,40);
    self.sendButton.backgroundColor = [UIColor grayColor];
    [self.sendButton.layer setCornerRadius:10];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendButton];
    
    self.startStopButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startStopButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:self.startStopButtonItem animated:YES];
    
    self.settingButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting" style:UIBarButtonItemStylePlain target:self action:@selector(editSetting:)];
    self.navigationItem.rightBarButtonItem = self.self.settingButtonItem;
    
    if (udpSocketServer == nil || udpSocketClient== nil) {
        [self setupSocket];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 滑动后下滑到底部
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        CGRect newTextViewFrame = _inputTextView.frame;
        newTextViewFrame.origin.y = self.tableView.contentSize.height-(40);
        _inputTextView.frame = newTextViewFrame;
        
        CGRect newSendButtonFrame = _sendButton.frame;
        newSendButtonFrame.origin.y = self.tableView.contentSize.height-(40);
        _sendButton.frame = newSendButtonFrame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    [self.inputTextView resignFirstResponder];
}

-(void)sendMsg:(id)sender{
    NSString *host = self.setting.host;
    if ([host length] == 0)
    {
        NSLog(@"Address required");
        return;
    }
    
    int port = [self.setting.port intValue];
    if (port <= 0 || port > 65535)
    {
        NSLog(@"Valid port required");
        return;
    }
    
    NSString *msg = self.inputTextView.text;
    if ([msg length] == 0)
    {
        NSLog(@"Message required");
        return;
    }
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocketClient sendData:data toHost:host port:port withTimeout:-1 tag:0];
    
    Msg *msgInfo = [[Msg alloc] initWithMsg:msg initWithCreated:[NSDate date]];
    [self refreshTableView:msgInfo];
}

-(void)refreshTableView:(Msg *) msg{
    [self.msgArray addObject:msg];
    [self.tableView reloadData];
    
    //这里tableview不滑动，有待解决
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
//        [self.tableView scrollToRowAtIndexPath:[[NSIndexPath alloc] initWithIndex:self.msgArray.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startStopButtonPressed:) name:UITouchPhaseBegan object:nil];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [self.inputTextView resignFirstResponder]; return NO;
    }
    return YES; 
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 根据老的 frame 设定新的 frame
    CGRect newTextViewFrame = _inputTextView.frame;
    newTextViewFrame.origin.y = keyboardRect.origin.y - _inputTextView.frame.size.height;
    CGRect newSendButtonFrame = _sendButton.frame;
    newSendButtonFrame.origin.y = keyboardRect.origin.y - _sendButton.frame.size.height;
    
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    // 开始及执行动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    _inputTextView.frame = newTextViewFrame;
    _sendButton.frame = newSendButtonFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // 键盘的动画时间，设定与其完全保持一致
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 键盘的动画是变速的，设定与其完全保持一致
    NSValue *animationCurveObject =[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    CGRect newTextViewFrame = _inputTextView.frame;
    newTextViewFrame.origin.y = DEVICE_HEIGHT - _inputTextView.frame.size.height - 69;
    _inputTextView.frame = newTextViewFrame;
    
    CGRect newSendButtonFrame = _sendButton.frame;
    newSendButtonFrame.origin.y = DEVICE_HEIGHT - _inputTextView.frame.size.height - 69;
    _sendButton.frame = newSendButtonFrame;
    [UIView commitAnimations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.msgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"udpCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"udpCell"];
    }
    
    cell.textLabel.text = [self.msgArray[indexPath.row] message];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *createDate = [dateFormat stringFromDate:[self.msgArray[indexPath.row] created]];
    cell.detailTextLabel.text = createDate;
    
//    cell.imageView.image = [UIImage imageNamed:@"avatar"];
    
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


    return cell;
}


- (IBAction)startStopButtonPressed:(id)sender
{
    
    if (isRunning)
    {
        // STOP udp echo server
        
        [udpSocketServer close];
        
        NSLog(@"Stopped Udp Echo server");
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭UDP服务" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
        isRunning = false;

        [_startStopButtonItem setTitle:@"Start"];
    }
    else
    {
        
        NSError *error = nil;
        
        if (![udpSocketServer bindToPort:[self.setting.port intValue] error:&error])
        {
            NSLog(@"Error starting server (bind): %@", error);
            return;
        }
        if (![udpSocketServer beginReceiving:&error])
        {
            [udpSocketServer close];
            
            NSLog(@"Error starting server (recv): %@", error);
            return;
        }
        
        NSLog(@"Start Udp Echo server on port >>> %hu",[udpSocketServer localPort]);
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开启UDP服务" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
        isRunning = YES;

        [_startStopButtonItem setTitle:@"Stop"];
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSLog(@"%@",msg);
        
        Msg *msgInfo = [[Msg alloc] initWithMsg:msg initWithCreated:[NSDate date]];
        [self refreshTableView:msgInfo];
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }
    
    [udpSocketServer sendData:data toAddress:address withTimeout:-1 tag:0];
}

- (IBAction)editSetting:(id)sender{
    ViewController *vc = [[ViewController alloc] init];
    vc.setting = self.setting;

    [self.navigationController pushViewController:vc animated:YES];
}


@end
