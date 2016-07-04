//
//  ServerProcessManager.h
//  Pods
//
//  Created by Nikish Parikh on 6/27/16.
//
//

#import <Foundation/Foundation.h>

@protocol ServerProcessManagerDelegate <NSObject>

- (void) onProcessResponse;


@end

@interface ServerProcessManager :  NSObject
+ (ServerProcessManager*) sharedInstance;
- (void) runProcessWith:(NSString *) name parameters:(NSArray *) args  delegate:(id<ServerProcessManagerDelegate>)delegate;

@end
