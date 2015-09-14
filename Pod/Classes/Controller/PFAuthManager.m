//
//  PFAuthManager.m
//  Percero
//
//  Created by Jeff Wolski on 4/16/13.
//
//

#import "PFAuthManager.h"
#import "EnvConfig.h"
#import "PFClient.h"

@interface PFAuthManager () 

@property (nonatomic, strong)  PFOauthViewController *oauthAuthenticationViewController;
+ (PFAuthManager *)sharedInstance;

@end

static PFAuthManager *_sharedInstance = nil;

@implementation PFAuthManager

+ (void)loginWithOauthKeypath:(NSString *)keypath
             completionTarget:(UIViewController *)clientViewController{
    [self sharedInstance].delegate = nil;
    if ([clientViewController conformsToProtocol:@protocol(PFAuthManagerDelegate)]) {
        [self sharedInstance].delegate =(id<PFAuthManagerDelegate>)clientViewController;
    }
    [[self sharedInstance] authorizeWithGitHubKeypath:keypath completionTarget:clientViewController];
}

+ (NSArray *)oauthProviderKeys{
    NSArray * result = [[EnvConfig sharedInstance] oauthProviderKeys];
    return result;
}

- (void) authorizeWithGitHubKeypath:(NSString *)keyPath
                   completionTarget:(UIViewController *)clientViewController{
    self.oauthAuthenticationViewController = [[PFOauthViewController alloc] init];
    PFOauthViewController *controller = (PFOauthViewController *)self.oauthAuthenticationViewController;
    controller.oauthKey = keyPath;
    controller.delegate = self;
    [clientViewController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - PFGitHubOauthDelegate

- (void)authenticationFailed{
    [self.delegate authenticationFailed];
}

- (void)authenticationSucceededWithCode:(NSString *)code{

    [PFClient loginWithOAuthCode:code oauthKey:self.oauthAuthenticationViewController.oauthKey callbackTarget:self method:@selector(didLogin:)];
}
- (void) didLogin:(id) package{
    [(UIViewController *)(self.delegate) dismissViewControllerAnimated:YES completion:^{
        [self.delegate authenticationSucceeded];
    }];
    
}

#pragma mark -
+ (PFAuthManager *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}


//- (id)init
//{
//    self = [super init];
//    
//    if (self) {
//
//    }
//    
//    return self;
//}


+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


//
//

@end