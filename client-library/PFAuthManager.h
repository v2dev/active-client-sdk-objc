//
//  PFAuthManager.h
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PFGitHubOauthViewController.h"

@protocol PFAuthManagerDelegate <NSObject>

- (void) authenticationSucceeded;
- (void) authenticationFailed;

@end

@interface PFAuthManager : NSObject <PFGitHubOauthDelegate>
+ (NSArray *) oauthProviderKeys;
+ (void) loginWithOauthKeypath:(NSString *) keypath completionTarget:(UIViewController *)clientViewController;
@property (nonatomic, weak) id<PFAuthManagerDelegate> delegate;
@end
