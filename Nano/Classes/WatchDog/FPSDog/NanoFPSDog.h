//
//  NanoFPSDog.h
//  NanoDemo
//
//  Created by Steven on 2017/11/13.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NanoFPSDog : NSObject

+ (NanoFPSDog *)shareInstance;
-(void)start;
-(void)stop;
@end
