//
//  PFConnection.h
//  PerceroFramework
//
//  Created by John Coumerilh on 2/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFConnection : NSObject
@property (assign, nonatomic) BOOL isConnected;
+ (PFConnection*) sharedInstance;
+ (void) initialize;
- (void) listenForConnection:(SEL)selector target:(id)target;
- (void) loginAndListenForCompletion:(SEL)selector target:(UIViewController *)clientViewController;
@end
                