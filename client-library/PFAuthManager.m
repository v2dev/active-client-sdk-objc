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
             delegate:(UIViewController *)clientViewController{
    [self sharedInstance].delegate = nil;
    self.sharedInstance.isAuthenticating = true;
    if ([clientViewController conformsToProtocol:@protocol(PFAuthManagerDelegate)]) {
        [self sharedInstance].delegate =(id<PFAuthManagerDelegate>)clientViewController;
    }
    [[self sharedInstance] authorizeWithGitHubKeypath:keypath completionTarget:clientViewController];
}

- (void) loginWithAuthenticationProvider:(NSString *)authProvider
                              credential:(NSString *)credential
                                delegate:(id<PFAuthManagerDelegate>)delegate {
  self.isAuthenticating = true;
  self.delegate = delegate;
  [PFClient loginWithAuthenticationProvider:authProvider credential:credential callbackTarget:self method:@selector(providerBasedAuthenticationDidCompleteWithSuccess:)];
    
}


+ (NSArray *)oauthProviderKeys{
    NSArray * result = [[EnvConfig sharedInstance] oauthProviderKeys];
    return result;
}

- (void) authorizeWithGitHubKeypath:(NSString *)keyPath
                   completionTarget:(UIViewController *)clientViewController{
    self.isAuthenticating = true;
    self.oauthAuthenticationViewController = [[PFOauthViewController alloc] init];
    PFOauthViewController *controller = (PFOauthViewController *)self.oauthAuthenticationViewController;
    controller.oauthKey = keyPath;
    controller.delegate = self;
    [clientViewController presentViewController:controller animated:YES completion:nil];
}


#pragma mark - Provider Based Login Callback
-(void) authenticationDidSucceed {
    [self.delegate authenticationSucceeded];
}

-(void) authenticationDidFailWithError:(NSError *)error {
    [self.delegate authenticationFailedWithError:error];
}


#pragma mark - PFGitHubOauthDelegate

- (void)authenticationFailed{
    self.isAuthenticating = false;
    NSError *error = [NSError errorWithDomain:@"com.activestack.error" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Authentication Failed."}];
    [self.delegate authenticationFailedWithError:error];
}

- (void)authenticationSucceededWithCode:(NSString *)code{
    self.isAuthenticating = false;
    [PFClient loginWithOAuthCode:code oauthKey:self.oauthAuthenticationViewController.oauthKey callbackTarget:self method:@selector(didLogin:)];
}
- (void) didLogin:(id) package{
  self.isAuthenticating = false;
  [self.delegate authenticationSucceeded];
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
