//
//  NanoStack.m
//  Steven
//
//  Created by Steven on 2017/10/19.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import "NanoStack.h"
#import "NanoThreadTrace.h"
#import "UIDevice+afm_Hardware.h"
#import <mach/mach.h>


@implementation NanoStack

+ (NSString*)allThreadSymbols {
    
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount;
    
    /* 获取当前线程列表 */
    if (task_threads(mach_task_self(), &threads, &threadCount) != KERN_SUCCESS) {
        threadCount = 0;
    }
    
    /* 2.挂起所有线程，除了当前线程 */
    for (mach_msg_type_number_t i = 0; i < threadCount; i++) {
        if (threads[i] != nano_mach_thread_self())
            thread_suspend(threads[i]);
    }
    
    // 3. 获取所有线程的stackTrace信息
    NSMutableArray *stacksArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < threadCount; ++i) {
        thread_t tmpThread = threads[i];
        NSString *stackTrace = traceForThread(tmpThread);
        if (stackTrace) {
            [stacksArray addObject:stackTrace];
        }
    }
    
    // 4. 激活被挂起的线程
    for (int i = 0; i < threadCount; ++i) {
        thread_resume(threads[i]);
    }
    // 5. 格式化输出stackTrace log信息,写入日记文件
    return [NanoStack formatLogsWithArray:stacksArray];
}

/* 格式化输出stackTrace log信息,写入日记文件 */
+ (NSString*)formatLogsWithArray:(NSArray*)array {

    NSMutableString *logs = nil;
    if (array.count) {
        
        NSString *timeStamp = [NanoStack timeStamp];
        
        logs = [[NSMutableString alloc] initWithCapacity:0];
        
        [logs appendFormat:@"\n**************************************\n"];
        [logs appendFormat:@"Time: %@\n", timeStamp];
        UIDevice *device = [UIDevice currentDevice];
        [logs appendFormat:@"Device: %@, %@\n\n", device.platformString, device.systemVersion];
        for(NSInteger idx = 0; idx < array.count; idx++) {
            [logs appendFormat:@"%@", array[idx]];
            [logs appendFormat:@"\n------------------------------------\n"];
        }
        [logs appendFormat:@"\n**************************************\n\n\n"];
    }
    return logs;
}

/* 时间戳 */
+ (NSString *)timeStamp
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone localTimeZone];
    df.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *timeStamp = [df stringFromDate:curDate];
    return timeStamp;
}

@end
