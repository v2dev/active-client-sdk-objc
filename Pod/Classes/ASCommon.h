//
//  ASCommon.h
//  Pods
//
//  Created by Dee Jay on 9/14/15.
//
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(...) NSLog(@"\n******************************\n%s %d %@\n******************************\n", __PRETTY_FUNCTION__,__LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#endif