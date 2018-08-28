//
//  NanoLog.h
//  NanoDemo
//
//  Created by steven on 2018/8/28.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NanoLogProtocol <NSObject>
- (void)nanoLogDelegateWithLogs:(NSString*)log;  //如果需要写入定制的日志系统，可以通过此处获得
@end


@interface NanoLog : NSObject
@property(nonatomic,weak)id<NanoLogProtocol> delegate;

+ (NanoLog *)shareInstance;

-(void)printLogs:(NSString*)logs;
@end
