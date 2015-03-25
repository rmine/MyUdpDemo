//
//  Setting.m
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/25.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import "Setting.h"

@implementation Setting

-(id)initWithHost:(NSString *)host initWithCreated:(NSNumber *) port{
    self = [super init];
    if(self){
        self.host = host;
        self.port = port;
    }
    return self;
}

@end
