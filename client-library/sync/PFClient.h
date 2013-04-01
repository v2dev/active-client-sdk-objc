//
//  PFClient.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"

@class PFSocketManager;

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
}

@property (nonatomic, readonly) PFSocketManager* syncManager;
@property (nonatomic, retain) NSString* clientId;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSString* accessToken;
@property (nonatomic, retain) NSString* refreshToken;
@property (nonatomic, readonly) NSMutableArray* regAppOAuths;
@property (nonatomic, retain) NSMutableSet* authListeners;

+ (PFClient*) sharedInstance;
+ (void) addListenerForAuthEvents:(NSObject*)target method:(SEL)selector;
+ (bool) loginWithOAuthCode:(NSString*) oauthCode callbackTarget:(NSObject*) target method:(SEL) selector;
+ (void) loginSavedSessionWithCallbackTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendGetAllByNameRequest:(NSString*)className target:(NSObject*) target method:(SEL) selector;
+ (void) sendGetByIdRequest:(NSString*)className id:(NSString*)id target:(NSObject*) target method:(SEL) selector;
+ (void) sendPutRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendCreateRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (void) sendRemoveRequestWithClass:(NSString*)className object:(PFModelObject *) object completionTarget:(NSObject*) target method:(SEL) selector;
+ (bool) isAuthenticated;
+ (void) autoLogin;
+ (void) logout;
//+ (void) save;

@end
