//
//  NanoTick.m
//  Steven
//
//  Created by  on 2017/9/30.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import "NanoTick.h"

#import <mach/mach_time.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

static uint64_t preTick = 0;



double subtractTimes( uint64_t endTime, uint64_t startTime );


double nanoTime(void)
{
    uint64_t tick = nanoTick();
    double time = subtractTimes(tick, preTick);
    preTick = tick;
    return time;
}

uint64_t nanoTick(void)
{
    return mach_absolute_time(); //纳秒
}

uint64_t nanoMachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer / (double)timebase.denom /1e9;
}

double subtractTimes( uint64_t endTime, uint64_t startTime )
{
    uint64_t difference = endTime -startTime;
    static double conversion = 0.0;
    if( conversion == 0.0 )
    {
        mach_timebase_info_data_t info;
        kern_return_t err = mach_timebase_info( &info );                       //Convert the timebaseinto seconds
        if(err == 0  )
            conversion= 1e-9 * (double) info.numer / (double) info.denom;
    }
    return conversion * (double)difference;
}




