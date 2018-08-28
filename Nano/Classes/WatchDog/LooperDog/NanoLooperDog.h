//
//  NanoLooperDog.h
//  Steven
//
//  Created by Steven on 2017/10/18.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NanoLooperDog : NSObject

+ (NanoLooperDog *)shareInstance;
-(void)start;
-(void)stop;
@end
