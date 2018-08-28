//
//  NanoFPSView.m
//  NanoDemo
//
//  Created by Steven on 2017/11/14.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "NanoFPSView.h"

#define kNiceFPSNum 40
#define kOKFPSNum 30


#define kNiceFPSColor [UIColor greenColor]
#define kOKFPSColor [UIColor orangeColor]
#define kBadFPSColor [UIColor redColor]




@interface NanoFPSView ()

@property(nonatomic,strong)UILabel* fpsLabel;
@end

@implementation NanoFPSView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI {
    
    [self addSubview:self.fpsLabel];
}


#pragma mark - setters
-(void)setFps:(NSInteger)fps {
    _fps = fps;
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS : %ld",fps];
    
    if (fps < kOKFPSNum) {
        self.fpsLabel.backgroundColor = kBadFPSColor;
    }else if ((fps < kNiceFPSNum) && fps > kOKFPSNum ) {
        self.fpsLabel.backgroundColor = kOKFPSColor;
    }else {
        self.fpsLabel.backgroundColor = kNiceFPSColor;
    }
}


#pragma mark - getters
-(UILabel*)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _fpsLabel.backgroundColor = [UIColor whiteColor];
        _fpsLabel.layer.borderWidth = 1;
        _fpsLabel.layer.borderColor = [[UIColor orangeColor] CGColor];
        _fpsLabel.layer.cornerRadius = 8;
        _fpsLabel.layer.masksToBounds = YES;
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _fpsLabel;
}

@end
