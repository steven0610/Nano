//
//  NanoLog.m
//  NanoDemo
//
//  Created by steven on 2018/8/28.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "NanoLog.h"

static NanoLog* _instance = nil;


@implementation NanoLog

#pragma mark - Singleton override
+ (NanoLog *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NanoLog alloc] init];
    });
    
    return _instance;
}

-(void)printLogs:(NSString*)logs {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(nanoLogDelegateWithLogs:)]) {
        [self.delegate nanoLogDelegateWithLogs:logs];
    }else{
        NSLog(@"%@",logs);
    }
}
@end
