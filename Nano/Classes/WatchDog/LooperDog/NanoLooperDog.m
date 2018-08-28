//
//  NanoLooperDog.m
//  Steven
//
//  Created by Steven on 2017/10/18.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import "NanoLooperDog.h"
#import "NanoStack.h"
#import "NanoLog.h"

static NanoLooperDog* _instance = nil;

static int timeoutCount;
static CFRunLoopObserverRef observer;

static dispatch_semaphore_t semaphore;
static CFRunLoopActivity activity;


@implementation NanoLooperDog

#pragma mark - Singleton override
+ (NanoLooperDog *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NanoLooperDog alloc] init];
    });
    
    return _instance;
}

- (void)dealloc {
    [self stop];
}

-(void)start {
    if (observer)
        return;
    
    // 信号
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runLoopObserverCallBack,
                                        &context);
    dispatch_async(dispatch_get_main_queue(),^{
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    });
    
    
    
    [self startTimeWatch];
    
}


/*
 * 在子线程监控时长
 */
-(void)startTimeWatch {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting)
                {
                    if (++timeoutCount < 5)/* 当前判断为 50*5 ＝250毫秒 */
                        continue;
                    
                    [self callKartun];
                }
            }
            timeoutCount = 0;
        }
    });
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity act, void *info) {
    activity = act;
    
    dispatch_semaphore_t sp = semaphore;
    dispatch_semaphore_signal(sp);
}

- (void)stop {
    if (!observer)
        return;
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

-(void)callKartun {
    NSString* stacks = [NanoStack allThreadSymbols];
    [[NanoLog shareInstance] printLogs:stacks];
}

@end

