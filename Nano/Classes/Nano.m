//
//  Nano.m
//  NanoDemo
//
//  Created by Steven on 2017/11/14.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "Nano.h"
#import "NanoUIUtils.h"
#import "NanoFPSView.h"



#define kFPSView_WIDTH 60
#define kFPSView_HEIGHT 20

@interface Nano ()

@property(nonatomic,strong) NanoFPSView* fpsView;
@end


@implementation Nano



static Nano* _instance = nil;
#pragma mark - Singleton override
+ (Nano *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Nano alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addFpsView];
    }
    return self;
}

- (void)addFpsView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow addSubview:self.fpsView];
        });
    });
}




#pragma mark - setter
- (void)setFpsViewShow:(BOOL)fpsViewShow {
    _fpsViewShow = fpsViewShow;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fpsView.hidden = !fpsViewShow;
    });
}

- (void)setFps:(NSInteger)fps {
    _fps = fps;
    self.fpsView.fps = fps;
}


#pragma mark - getter
- (NanoFPSView*)fpsView {
    if (!_fpsView) {
        _fpsView = [[NanoFPSView alloc] initWithFrame:CGRectMake(NANO_SCREEN_WIDTH - kFPSView_WIDTH - 10 , 20, kFPSView_WIDTH, kFPSView_HEIGHT)];
    }
    return _fpsView;
}


@end
