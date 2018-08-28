//
//  Nano.h
//  Nano
//
//  Created by steven on 2018/8/28.
//  Copyright © 2018年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NanoFPSDog.h"
#import "NanoLooperDog.h"

//! Project version number for Nano.
FOUNDATION_EXPORT double NanoVersionNumber;
//! Project version string for Nano.
FOUNDATION_EXPORT const unsigned char NanoVersionString[];


@interface Nano : NSObject

@property(nonatomic,assign)BOOL fpsViewShow;
@property(nonatomic,assign)NSInteger fps;

+ (Nano *)shareInstance;
@end


