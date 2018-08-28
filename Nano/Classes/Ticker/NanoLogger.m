//
//  NanoLogger.m
//  Steven
//
//  Created by  on 2017/9/30.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import "NanoLogger.h"
#import "NanoTick.h"

void logNano(void)
{
    double time = nanoTime();
    NSLog(@"nanoTick = %f Seconds",time);
}

void logNanoWithDes(NSString* des)
{
    if (des) {
        NSLog(@"%@ %f Seconds",des,nanoTime());
    }else{
        logNano();
    }
}
