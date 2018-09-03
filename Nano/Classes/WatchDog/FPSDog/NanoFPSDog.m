//
//  NanoFPSDog.m
//  NanoDemo
//
//  Created by Steven on 2017/11/13.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "NanoFPSDog.h"
#import <QuartzCore/QuartzCore.h>
#import "Nano.h"
#import "NanoFPSListener.h"
#import "NanoTick.h"
#import "NanoStack.h"
#import "NanoLog.h"



#define kNanoFPSDog_Watch_Queue "____NanoFPSDog_Watch_Queue____"

#define kNanoFPSDogGapDefaultTime 200



@interface NanoFPSDog ()

@property(nonatomic,strong) dispatch_source_t timer;
@property(nonatomic,assign) int gapTime;
@end

@implementation NanoFPSDog


static NanoFPSDog* _instance = nil;

#pragma mark - Singleton override
+(NanoFPSDog *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NanoFPSDog alloc] init];
    });
    
    return _instance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _gapTime = kNanoFPSDogGapDefaultTime;
    }
    return self;
}

-(void)start {
    [[NanoFPSListener shareInstance] start];
    [self startWatchWithMSec:_gapTime];
}

-(void)stop {
    dispatch_suspend(_timer);
}


#pragma mark -
/*
 * 在子线程监控时长
 */
-(void)startWatchWithMSec:(uint64_t)msec {
    //间隔还是200毫秒
    uint64_t interval = msec * NSEC_PER_MSEC;
    //创建一个专门执行timer回调的GCD队列
    dispatch_queue_t queue = dispatch_queue_create(kNanoFPSDog_Watch_Queue, 0);
    //创建Timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    
    __block uint64_t preTick = 0;
    __block uint64_t preTagTick = 0;
    dispatch_source_set_event_handler(_timer, ^() {
        
        uint64_t fpsTick = [NanoFPSListener shareInstance].tick;
        if (fpsTick == preTick) {
            if (fpsTick == 0  /* 还没有初始化完毕 */
                || preTagTick == fpsTick) { /* 已经记录过 */
                return ;
            }
            
            preTagTick = fpsTick;
            [self callKartun];
//            NSLog(@"Timer %@", [NSThread currentThread]);
//            NSLog(@"nano ka fpsTick = %lld",fpsTick);
        }else {
            preTick = fpsTick;
        }
    });
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(_timer);
}

static bool isCalling;
-(void)callKartun {
    
    if (isCalling) {
        return;
    }
    
    isCalling = YES;
    NSString* stacks = [NanoStack allThreadSymbols];
    [[NanoLog shareInstance] printLogs:stacks];
    isCalling = NO;
}

@end
