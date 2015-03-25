//
//  Setting.h
//  MyUdpDemo
//
//  Created by huangzhaorong on 15/3/25.
//  Copyright (c) 2015年 huangzhaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSNumber *port;

-(id)initWithHost:(NSString *)host initWithCreated:(NSNumber *) port;
@end
