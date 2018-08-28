//
//  NanoThreadTrace.h
//  Steven
//
//  Created by Steven on 2017/10/24.
//  Copyright © 2017年 Steven Culture co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach/mach.h>

int nanoThreadCallStacks(thread_t thread, void** callstack, int maxCount);
NSString* traceForThread(thread_t thread);
thread_t nano_mach_thread_self (void);
