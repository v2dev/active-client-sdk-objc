//
//  PFClient.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "IUserAnchor.h"
#import "Reachability.h"
#import "AuthenticationRequest.h"


@class PFSocketManager;
@class PushCWUpdateRequest;

@protocol AuthenticationDelegate <NSObject>

-(void) authenticationDidSucceed;
-(void) authenticationDidFailWithError:(NSError *)error;

@end

@interface PFClient : NSObject <NSCoding>{
    PFSocketManager* syncManager;
    NSString* clientId;
    NSString* userId;
    NSString* token;
    NSString* appKey;
    NSString* appSecret;
    NSMutableArray* regAppOAuths;
    NSString* accessToken;
    NSString* refreshToken;
    NSMutableSet* authListeners;
    NSTimer *loginTimeOutTimer;
}
@property (nonatomic, copy) NetworkReachable reachableBlock;
@property (nonatomic, copy) NetworkUnreachable unReachableBlock;
@property (nonatomic, strong) NSString *lastOauthKey;
@property (nonatomic, readonly) PFSocketManager* syncManager;
@property (nonatomic, retain) NSString* clientId;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSString* accessToken;
@property (nonatomic, retain) NSString* refreshToken;
@property (nonatomic, readonly) NSMutableArray* regAppOAuths;
@property (nonatomic, retain) NSMutableSet* authListeners;
@property (nonatomic, strong) id<IUserAnchor> currentUser;

@property (nonatomic, strong) id <AuthenticationDelegate> authDelegate;


+ (Class) iUserAnchorClass;
+ (NSString *) appName;
+ (PFClient*) sharedInstance;
+ (void) addListenerForAuthEvents:(NSObject*)target method:(SEL)selector;
+ (bool) loginWithAuthenticationProvider:(NSString *)authProvider credential:(NSString *)credential callbackTarget:(NSObject *)target method:(SEL)selector;
+ (bool) loginWithOAuthCode:(NSString*) oauthCode oauthKey:(NSString *) oauthKey callbackTarget:(NSObject*) target method:(SEL) selector;
+ (void) loginSavedSessionWithCallbackTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendFindByExampleRequest:(PFModelObject<IUserAnchor,PFModelObject> *) example target:(NSObject*) target method:(SEL) selector;
+ (void) sendGetAllByNameRequest:(NSString*)className target:(NSObject*) target method:(SEL) selector;
+ (void) sendPutRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendCreateRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendRemoveRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendPushCWRequestWithEntity:(PFModelObject *) entity fieldName:(NSString *) fieldName parameters:(NSArray *)parameters target:(NSObject*) target method:(SEL) selector;

+ (BOOL) isConnected;
+ (bool) isAuthenticated;
+ (void) autoLogin;
+ (void) logout;
+ (void) save;

+ (bool) registerWithAuthenticationProvider:(NSString *)authProvider credential:(NSString *)credential callbackTarget:(id<AuthenticationDelegate>)target method:(SEL)selector;
+ (AuthenticationRequest *)newRegisterRequestWithAuthenticationProvider:(NSString *)authProvider Credential:(NSString *)credential;

+ (void) sendRunProcessWithName:(NSString *) name parameters:(NSArray *) args target:(NSObject*) target method:(SEL) selector;


@end
