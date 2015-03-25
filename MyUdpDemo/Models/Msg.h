//
//  Msg.h
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Msg : NSObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *created;

-(id)initWithMsg:(NSString *)msg initWithCreated:(NSDate *) created;

@end
