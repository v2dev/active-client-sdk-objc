//
//  PFConnection.h
//  PerceroFramework
//
//  Created by John Coumerilh on 2/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFConnection : NSObject 
- (void) connectWithCallback:(SEL)selector target:(UIViewController *)target;
- (void) receivedConnectCallback:(UIViewController *)target;

- (void) loginWithCallback:(SEL)selector target:(UIViewController *)clientViewController;
- (void) receivedLoginCallback:(UIViewController *)target;

@end
                