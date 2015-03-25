//
//  Msg.m
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/24.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import "Msg.h"

@implementation Msg

-(instancetype)init{
    return [super init];
}

-(id)initWithMsg:(NSString *)message initWithCreated:(NSDate *) created{
    self = [super init];
    if(self){
        self.message = message;
        self.created = created;
    }
    return self;
}

@end
