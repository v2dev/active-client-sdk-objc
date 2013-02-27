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
@end

@implementation PFConnection

- (void) connectWithCallback:(SEL)selector target:(UIViewController *)clientViewController{
    
    if(clientViewController && selector){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        //Register for the "ConnectCompleted" notification on behalf of the client
        [nc addObserver:clientViewController
               selector:selector
                   name:@"ConnectCompleted"
                 object:nil];
        
        //Register for the "modelDidChangeServiceApplicationOAuth" for self
        [nc addObserver:self
               selector:@selector(modelDidChangeServiceApplicationOAuth:)
                   name:@"modelDidChangeServiceApplicationOAuth"
                 object:nil];
    }
    
}


- (void) loginWithCallback:(SEL)selector target:(id)target{
    
    if(target && selector){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:target
           selector:selector
               name:@"LoginCompleted"
             object:nil];
    }
    
    EnvConfig* config = [EnvConfig sharedInstance];
    
    GTMOAuth2ViewControllerTouch *viewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[config getEnvProperty:@"oauth.google.scope"]
                                               clientID:self.saOAuth.appKey
                                           clientSecret:@""
                                       keychainItemName:[config getEnvProperty:@"oauth.google.keychain_item_name"]
                                               delegate:self
                                       finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    self.clientViewController=target;
    [target presentViewController:viewController animated:YES completion:nil];
}

    
- (void) modelDidChangeServiceApplicationOAuth:(NSNotification*)n{
    EntityManager* em = [EntityManager sharedInstance];
    NSDictionary* saOAuths = [em dictionaryForClass:@"ServiceApplicationOAuth"];
    for (NSString* oa in saOAuths) {
        self.saOAuth = [saOAuths valueForKey:oa];
        if([self.saOAuth.serviceApplication.serviceProvider.name isEqualToString:@"google"]){
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"ConnectCompleted" object:nil userInfo:nil];
        }
    }
}

/**
 * This is the callback function that will be called when OAuth completes.
 * If success then we want to send the authCode to the server and start the login process there.
 * If fail then report the failure.
 */
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


-(void) pfLoginCompleted:(NSNumber*) result
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if([result boolValue]){
        [nc postNotificationName:@"LoginCompleted" object:self userInfo:nil];//TODO: We may want to send user information indicating pass/fail
    }
    else{
        [nc postNotificationName:@"LoginCompleted" object:self userInfo:nil];//TODO: We may want to send user information indicating pass/fail
    }
}






@end
