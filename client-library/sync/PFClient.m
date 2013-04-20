//
//  PFClient.m
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFClient.h"
#import "UserToken.h"
#import "AuthenticateOAuthCodeResponse.h"
#import "AuthenticateOAuthAccessTokenResponse.h"
#import "AuthenticateOAuthAccessTokenRequest.h"
#import "User.h"
#import "EnvConfig.h"
#import "AuthenticateOAuthCodeRequest.h"
#import "GetRegAppOAuthsResponse.h"
#import "GetRegAppOAuthsRequest.h"
#import "ServiceApplicationOAuth.h"
#import "EntityManager.h"
#import "PFSocketManager.h"
#import "GetAllByNameRequest.h"
#import "FindByIdRequest.h"
#import "PutRequest.h"
#import "CreateRequest.h"
#import "RemoveRequest.h"

// The singleton
static PFClient* _sharedInstance;

@implementation PFClient
@synthesize syncManager, clientId, token, userId, regAppOAuths, authListeners, accessToken, refreshToken;


/**
 * This method sets up everything to initialize the PFClient
 */
- (void) setup{
        
    authListeners = [[NSMutableSet alloc] init];

    // The PFSocketManager will issue this message when it gets connected
    [PFSocketManager addListenerForConnectEvent:self method:@selector(socketConnected)];
    [PFSocketManager addListenerForReadyEvent:self method:@selector(socketReady)];
    
    // Pull some config values out of the configuration file
    EnvConfig* config = [EnvConfig sharedInstance];
    appKey = [config getEnvProperty:@"socket.appKey"];
    appSecret = [config getEnvProperty:@"socket.appSecret"];
    
    // Get the SocketManager
    syncManager = [PFSocketManager sharedInstance];
    

}

- (id) init{
    self = [super init];
    
    if(self && !_sharedInstance){
        // Initialize the client object
        _sharedInstance = self;
        
        [_sharedInstance setup];
    }
    
    return _sharedInstance;
}

/**
 * Method to obtain the singleton instance of the PFClient object
 */
+ (PFClient*) sharedInstance{
    if(!_sharedInstance){
        // Try to load the saved instance
        _sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:@"pfclient"];
        if(!_sharedInstance){
            _sharedInstance = [[PFClient alloc] init];
        }
    }
    
    if(!_sharedInstance.syncManager.isConnected){
        [_sharedInstance.syncManager connect];
    }
    
    return _sharedInstance;
}

/**
 * A convenience method to help the client application initialize the connection the PF
 */
+ (void) initialize{
    [PFClient sharedInstance];
}

/**
 * Sends out a message that the client has been authenticated or not
 */
- (void) announceAuthenticated:(bool) isSuccessful{
    NSNumber* success = [NSNumber numberWithBool:isSuccessful];
    for (PFInvocation* inv in authListeners) {
        [inv invokeWithArgument:success];
    }
}


/**
 * Callback method for when the login response is recieved
 */
- (void) receivedAuthenticateOAuthCodeResponse:(id) result{
    NSLog(@"PFClient Got auth response");
    if ([result isMemberOfClass:[AuthenticateOAuthCodeResponse class]]) {
        AuthenticateOAuthCodeResponse* response = (AuthenticateOAuthCodeResponse*) result;
        UserToken* userToken = response.result;
        clientId = userToken.clientId;
        userId = userToken.user.ID;
        token = userToken.token;
        refreshToken = response.refreshToken;
        accessToken = response.accessToken;
        
        [PFClient save];
    }
}

/**
 * Callback method for when the regAppOAuths response is recieved
 */
- (void) receivedGetRegAppOAuthsResponse{
     
}

/**
 * Callback method for the SocketManager when it gets connected
 */
- (void) socketConnected{
    [PFClient autoLogin];
}

/**
 * Callback method for when we recieve the ConnectResponse
 * object from the server... this signifies that we are ready to
 * start generating activity on the wire.
 */
- (void) socketReady{
    [self announceAuthenticated:true];
}

+ (void) addListenerForAuthEvents:(NSObject*)target method:(SEL)selector{
    PFInvocation* inv = [[PFInvocation alloc] initWithTarget:target method:selector];
    [[PFClient sharedInstance].authListeners addObject:inv];
}


/**
 * Service method to make it easier for the client application to issue a login request
 */ 
+ (bool) loginWithOAuthCode:(NSString*) oauthCode callbackTarget:(NSObject*)target method:(SEL)selector{
    
    if(target && selector)
        [PFClient addListenerForAuthEvents:target method:selector];
    
//    ServiceApplicationOAuth* saOAuth = [_sharedInstance.regAppOAuths objectAtIndex:0]; // ???: this is probably outdated
    AuthenticateOAuthCodeRequest* req = [[AuthenticateOAuthCodeRequest alloc] init];
    req.userId = @"";
    req.token = @"";
    req.clientType = @"N";
    req.clientId = @"";
    req.code = oauthCode;
    req.regAppKey = @"PM_2F30977"; // !!!: This should come from the env.plist
    req.deviceId = @"";
    req.authProvider = @"GITHUB"; // !!!: This should come from the env.plist
    PFInvocation* callback = [[PFInvocation alloc] initWithTarget:[PFClient sharedInstance] method:@selector(receivedAuthenticateOAuthCodeResponse:)];

    [[PFSocketManager sharedInstance] sendEvent:@"authenticateOAuthCode" data:req callback:callback];
    
    return true;
}

/**
 * this function will allow the client to re-authenticate using old credentials, so the user
 * doesn't have to login everytime.
 */
+ (void) autoLogin{
        
    // If we have old info to try to and renew our authenticated state then try
    if(_sharedInstance.token && _sharedInstance.clientId && _sharedInstance.accessToken && _sharedInstance.refreshToken){
        ServiceApplicationOAuth* saOAuth = [_sharedInstance.regAppOAuths objectAtIndex:0];

        AuthenticateOAuthAccessTokenRequest* req = [[AuthenticateOAuthAccessTokenRequest alloc] init];
        req.userId = [PFClient sharedInstance].userId;
        req.token = [PFClient sharedInstance].token;
        req.clientType = @"N";
        req.clientId = [PFClient sharedInstance].clientId;
        req.accessToken = [PFClient sharedInstance].accessToken;
        req.refreshToken = [PFClient sharedInstance].refreshToken; //saOAuth.serviceApplication.serviceProvider.;//@"psiglobal";
        req.svcOauthKey = saOAuth.appKey; //saOAuth.serviceApplication.serviceProvider.;//@"psiglobal";
        req.regAppKey = @"PSI_29V97G";
        req.deviceId = @"";
    
        PFInvocation* callback = [[PFInvocation alloc] initWithTarget:[PFClient sharedInstance] method:@selector(autoLoginCallback:)];
    
        [[PFSocketManager sharedInstance] sendEvent:@"authenticateOAuthAccessToken" data:req callback:callback];
    }
    
}


/**
 * The callback method for autologin
 */
- (void) autoLoginCallback:(id) result{
    
    if([result isKindOfClass:[AuthenticateOAuthAccessTokenResponse class]]){
        AuthenticateOAuthAccessTokenResponse* response = (AuthenticateOAuthAccessTokenResponse*) result;
        UserToken* userToken = response.result;
        clientId = userToken.clientId;
        userId = userToken.user.ID;
        token = userToken.token;
        refreshToken = response.refreshToken;
        accessToken = response.accessToken;
        [PFClient save];
    }
    else{
        NSLog(@"autoLoginCallback got invalid type of object");
    }
}

/**
 * Public static method to send a get all by name request
 */
+ (void) sendGetAllByNameRequest:(NSString*)className target:(NSObject*) target method:(SEL) selector{
    GetAllByNameRequest* request = [[GetAllByNameRequest alloc] init];
    [request setClientId:[PFClient sharedInstance].clientId];
    [request setToken:[PFClient sharedInstance].token];
    [request setUserId:[PFClient sharedInstance].userId];
    [request setTheClassName:className];
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"getAllByName" data:request callback:callback];
}

+ (void)sendPutRequestWithClass:(NSString *)className object:(PFModelObject *)object completionTarget:(NSObject *)target method:(SEL)selector {
    
    PutRequest * request = [[PutRequest alloc] init];
    request.clientId = [PFClient sharedInstance].clientId;
    request.token = [PFClient sharedInstance].token;
    request.userId = [PFClient sharedInstance].userId;
    request.theObject = object;
    request.putTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
    request.transId = [NSString stringWithFormat:@"%u%u%u%u", arc4random(), arc4random(), arc4random(), arc4random() ];
    request.sendAck = YES;
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"putObject" data:request callback:callback];
    
}

+ (void)sendCreateRequestWithClass:(NSString *)className object:(PFModelObject *)object completionTarget:(NSObject *)target method:(SEL)selector {
    
    CreateRequest* request = [[CreateRequest alloc] init];
    request.clientId = [PFClient sharedInstance].clientId;
    request.token = [PFClient sharedInstance].token;
    request.userId = [PFClient sharedInstance].userId;
    
    request.theObject = object;
    request.sendAck = YES;
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"createObject" data:request callback:callback];
    
}

+ (void)sendRemoveRequestWithClass:(NSString *)className object:(PFModelObject *)object completionTarget:(NSObject *)target method:(SEL)selector {
    
    RemoveRequest* request = [[RemoveRequest alloc] init];
    request.clientId = [PFClient sharedInstance].clientId;
    request.token = [PFClient sharedInstance].token;
    request.userId = [PFClient sharedInstance].userId;
    
    request.removePair = [object classIDPair];
    request.sendAck = YES;
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"removeObject" data:request callback:callback];
    
}

+ (void) sendGetByIdRequest:(NSString*)className id:(NSString*)id target:(NSObject*) target method:(SEL) selector{
    FindByIdRequest* request = [[FindByIdRequest alloc] init];
    [request setClientId:[PFClient sharedInstance].clientId];
    [request setToken:[PFClient sharedInstance].token];
    [request setUserId:[PFClient sharedInstance].userId];
    
    [request setTheClassName:className];
    [request setTheClassId:id];
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"findById" data:request callback:callback];

}


+ (bool) isAuthenticated{
    return (bool)[PFClient sharedInstance].token;
}

+ (void) save{
    [NSKeyedArchiver archiveRootObject:[PFClient sharedInstance] toFile:@"pfclient"];
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
//    if(self){
//        clientId = [aDecoder decodeObjectForKey:@"clientId"];
//        userId = [aDecoder decodeObjectForKey:@"userId"];
//        token = [aDecoder decodeObjectForKey:@"token"];
//        appKey = [aDecoder decodeObjectForKey:@"appKey"];
//        appSecret = [aDecoder decodeObjectForKey:@"appSecret"];
//        accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
//        refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
        
//        [self setup];
//        _sharedInstance = self;
//    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder*) coder{
    [coder encodeObject:clientId forKey:@"clientId"];
    [coder encodeObject:userId forKey:@"userId"];
    [coder encodeObject:token forKey:@"token"];
    [coder encodeObject:appKey forKey:@"appKey"];
    [coder encodeObject:appSecret forKey:@"appSecret"];
    [coder encodeObject:accessToken forKey:@"accessToken"];
    [coder encodeObject:refreshToken forKey:@"refreshToken"];
}

+ (void) logout{
    _sharedInstance.clientId = nil;
    _sharedInstance.token = nil;
    _sharedInstance.accessToken = nil;
    _sharedInstance.refreshToken = nil;
    _sharedInstance.userId = nil;
    [PFClient save];
}

+ (void)loginSavedSessionWithCallbackTarget:(NSObject *)target method:(SEL)selector{
    // !!!: not yet implemented
}



@end
