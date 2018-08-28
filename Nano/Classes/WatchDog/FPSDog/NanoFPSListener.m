//
//  NanoFPSListener.m
//  NanoDemo
//
//  Created by Steven on 2017/11/14.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "NanoFPSListener.h"
#import <QuartzCore/QuartzCore.h>
#import "Nano.h"
#import "NanoTick.h"

@interface NanoFPSListener ()

@property(nonatomic,strong) CADisplayLink * displayLink;

@property(nonatomic,assign) CFTimeInterval lastUpdateTimestamp;

@property(nonatomic,assign) NSUInteger historyCount;
@property(nonatomic,assign) NSInteger currentFPS;
@end


@implementation NanoFPSListener


static NanoFPSListener* _instance = nil;

#pragma mark - Singleton override
+(NanoFPSListener *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NanoFPSListener alloc] init];
    });
    
    return _instance;
}

-(id)init {
    self = [super init];
    if( self ){
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        _displayLink.frameInterval = 2;
        _displayLink.paused = YES;
        // TODO 测试tracking状态下能否正常运行
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return self;
}


-(void)start {
    _displayLink.paused = NO;
}


-(void)pause {
    [_displayLink setPaused:YES];
}

-(void)stop {
    _displayLink.paused = YES;
}


-(void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)displayLinkTick {
    _tick = nanoTick();
    
    if (_lastUpdateTimestamp <= 0) {
        _lastUpdateTimestamp = _displayLink.timestamp;
        return;
    }
    _historyCount += _displayLink.frameInterval;
    
    CFTimeInterval interval = _displayLink.timestamp - _lastUpdateTimestamp;
    if(interval >= 1) {
        _lastUpdateTimestamp = _displayLink.timestamp;
        _currentFPS = _historyCount / ((NSInteger)interval); /* 注意，这里要进行强转，否则 NSInteger/double会得出不准确的结果  */
        NSLog(@"_historyCount = %ld , interval = %f",_historyCount,interval);
        _historyCount = 0;
        [self updateFPSCount:_currentFPS];
    }
}


-(void)updateFPSCount:(NSInteger)fpsCount {
    NSLog(@"Current FPS = %ld",fpsCount);
    
    [Nano shareInstance].fps = fpsCount;
}

@end
