//
//  NanoFPSListener.h
//  NanoDemo
//
//  Created by Steven on 2017/11/14.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NanoFPSListener : NSObject

@property(nonatomic,assign)uint64_t tick;

+ (NanoFPSListener *)shareInstance;

-(void)start;
-(void)pause;
-(void)stop;
@end
