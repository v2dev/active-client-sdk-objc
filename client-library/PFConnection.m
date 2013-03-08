//
//  PFConnection.m
//  PerceroFramework
//
//  Created by John Coumerilh on 2/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import "PFConnection.h"
#import <Percero/Percero.h>
#import "GTMOAuth2ViewControllerTouch.h"

@interface PFConnection ()
@property (nonatomic, strong)ServiceApplicationOAuth* saOAuth;
@property (strong,nonatomic)  GTMOAuth2ViewControllerTouch *oathViewController;
@property (weak,nonatomic) UIViewController *clientViewController;
@property (assign, nonatomic) SEL connectionCallbackSelector;
@property (assign, nonatomic) SEL loginCallbackSelector;
@end

@implementation PFConnection


- (void) listenForConnection:(SEL)selector target:(UIViewController *)clientViewController{
    
    if(clientViewController && selector){
        
        self.clientViewController=clientViewController;
        self.connectionCallbackSelector = selector;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        //Register for the "modelDidChangeServiceApplicationOAuth"
        [nc addObserver:self
               selector:@selector(modelDidChangeServiceApplicationOAuth:)
                   name:@"modelDidChangeServiceApplicationOAuth"
                 object:nil];
    }
    
}


- (void) loginAndListenForCompletion:(SEL)selector target:(UIViewController *)clientViewController{
    
    self.clientViewController=clientViewController;
    self.loginCallbackSelector=selector;
    
    EnvConfig* config = [EnvConfig sharedInstance];
    
    GTMOAuth2ViewControllerTouch *viewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[config getEnvProperty:@"oauth.google.scope"]
                                               clientID:self.saOAuth.appKey
                                           clientSecret:@""
                                       keychainItemName:[config getEnvProperty:@"oauth.google.keychain_item_name"]
                                               delegate:self
                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [self.clientViewController presentViewController:viewController animated:YES completion:nil];
}


- (void) modelDidChangeServiceApplicationOAuth:(NSNotification*)n{
    EntityManager* em = [EntityManager sharedInstance];
    NSDictionary* saOAuths = [em dictionaryForClass:@"ServiceApplicationOAuth"];
    for (NSString* oa in saOAuths) {
        self.saOAuth = [saOAuths valueForKey:oa];
        if([self.saOAuth.serviceApplication.serviceProvider.name isEqualToString:@"google"]){
            [self pfConnectionCompleted];
        }
    }
}



// This is the callback function that will be called when login OAuth completes.
// If success then we want to send the authCode to the server and start the login process there.
// If fail then report the failure.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    //[self.clientViewController dismissViewControllerAnimated:YES completion:nil];
    if (error != nil) {
        NSLog(@"OAuth Error: %@", error);
    } else {
        NSLog(@"OAuth Success!");
        [PFClient loginWithOAuthCode:[auth code] callbackTarget:self method:@selector(pfLoginCompleted:)];
    }
}


-(void) pfConnectionCompleted
{
    if(self.clientViewController && self.connectionCallbackSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.clientViewController performSelector:self.connectionCallbackSelector];
#pragma clang diagnostic pop
    }
}


-(void) pfLoginCompleted:(NSNumber*) result
{
    if(self.clientViewController && self.loginCallbackSelector){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.clientViewController performSelector:self.loginCallbackSelector withObject:result];
#pragma clang diagnostic pop
    }
}
@end
