//
//  SyncManager.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFModelObject.h"
#import "PFSocketManager.h"
#import "EnvConfig.h"
#import "EntityManager.h"
#import "Utility.h"
#import "AuthRequest.h"
#import "SyncRequest.h"
#import "AuthResponse.h"
#import "SyncResponse.h"
#import "ConnectResponse.h"
#import "CreateRequest.h"
#import "CreateResponse.h"

@interface PFSocketManager ()

@property (nonatomic, readonly) NSMutableDictionary* syncRequests;

@end

static PFSocketManager* sharedInstance;

@implementation PFSocketManager
@synthesize socketIO, /*model,*/ isConnected;
- (NSMutableDictionary *)syncRequests{
    static NSMutableDictionary* syncRequests;
    
    if (!syncRequests) {
        syncRequests = [[NSMutableDictionary alloc] initWithCapacity:8];
    }
    
    return syncRequests;
}
+ (PFSocketManager*) sharedInstance{
    DLog(@"");
    if(!sharedInstance){
        sharedInstance = [[PFSocketManager alloc] init];
    }
    
    return sharedInstance;
}

- (void) connect{
    if(!isConnecting && !isConnected){
        /*
        * Setup the socket connection
        */
        EnvConfig* config = [EnvConfig sharedInstance];
        [socketIO connectToHost:[config getEnvProperty:@"socket.host"] onPort:[[config getEnvProperty:@"socket.port"] intValue]];
        isConnecting = true;
    }
}

- (id) init{
    self = [super init];
    if(self){
        isConnecting = false;
        callbacks = [[NSMutableDictionary alloc] init];
        socketIO = [[SocketIO alloc] initWithDelegate:self];

        [self connect];
    }
    return self;
}

- (void) cacheSyncRequest:(SyncRequest *) syncRequest{
    self.syncRequests[syncRequest.messageId] = syncRequest;
}

- (void) processSyncResponse:(SyncResponse *) syncResponse{
    
    if([syncResponse isKindOfClass:[ConnectResponse class]]){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"PFSocketReady" object:nil];
    }
    
    // check to see if there is a matching request
    SyncRequest *matchingRequest = self.syncRequests[syncResponse.correspondingMessageId];
    
    if (matchingRequest) {
        // handle various response classes
        
        if ([syncResponse isKindOfClass:[CreateResponse class]]) {
            CreateResponse *createResponse = (CreateResponse *) syncResponse;
            CreateRequest *createRequest = (CreateRequest *)matchingRequest;
            if (createResponse.result) {
                // TODO: notify the user that the creation was successful
            } else {
                [createRequest.theObject delete];
                // TODO: notify the user that the creation failed
            }
            
        } else if (/*[syncResponse isKindOfClass:[SomeOtherClass class]]*/0) {
            
        }
        
        // remove matchingRequest
        
        [self.syncRequests removeObjectForKey:syncResponse.correspondingMessageId];
        
    } else {
        
        if (/*this is a push response*/0) {
            // do something useful
        } else {
            // since we didn't request this and the server didn't push it, just ignore this request
        }
    
    }
    
    
    

}
/**
 * This method takes care of assigning a message Id and sending the object across the wire
 */
- (void) sendEvent:(NSString*)eventName data:(id<Serializable>)data callback:(PFInvocation *)inv {
    NSString* requestId = (__bridge_transfer NSString*) CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
    if([data isKindOfClass:[AuthRequest class]]){
        ((AuthRequest*)data).messageId = requestId;
    }
    else if([data isKindOfClass:[SyncRequest class]]){
        ((SyncRequest*)data).messageId = requestId;
        [self cacheSyncRequest:data];
    }
    
    if(inv){
        [callbacks setObject:inv forKey:requestId];
    }
    
    
    [socketIO sendEvent:eventName withData:[data toDictionary:NO]];
}

/**
 * Generic function for deserializing and sticking the proper objects
 * into the entity cache.
 */
- (id<Serializable>) deserializeObject:(id)obj{
    return [[EntityManager sharedInstance] deserializeObject:obj];    
}

/**************************
 * SocketIO Delegate Methods
 */
- (void) socketIODidConnect:(SocketIO *)socket{
    NSLog(@"Connected to socket!");
    isConnected = true;
    /**
     * Custom "connect" message required by PF Gateway
     */
    NSMutableDictionary* connectMessage = [[NSMutableDictionary alloc] init];
    [connectMessage setValue:@"connect" forKey:@"connect"];
    [socketIO sendEvent:@"message" withData:connectMessage];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"PFSocketConnected" object:nil];
    
    isConnecting = false;
}
- (void) socketIODidDisconnect:(SocketIO *)socket{
    NSLog(@"Disonnected from socket :(");
    isConnected = false;
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet{
    NSLog(@"Got Message: %@", packet.data);
    
}
- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet{
    NSLog(@"didReceiveJSON: %@", packet);
}

/*
 * Method that gets called when a message is recieved from the socket
 */
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet{
    NSDictionary* data = [packet dataAsJSON];    
    NSArray* args = [data objectForKey:@"args"];
    id message = [args objectAtIndex:0]; // The real data is in the first element
    id<Serializable> result = [self deserializeObject:message];
    
    if([[packet name] isEqualToString:@"gatewayConnectAck"]){
        
    }
    
    if(result){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:[NSString stringWithFormat:@"didReceive%@", [[result class] description]] 
                          object:nil 
                        userInfo:[NSDictionary dictionaryWithObject:result forKey:@"response"]];
        
        NSString* corrMessageId;
        if([result isKindOfClass:[AuthResponse class]]){
            corrMessageId = ((AuthResponse*)result).correspondingMessageId;
        }
        else if([result isKindOfClass:[SyncResponse class]]){
            corrMessageId = ((SyncResponse*)result).correspondingMessageId;
            [self processSyncResponse:result];
        }
        
        if (corrMessageId){
            // build ack
            NSDictionary *corrId = @{@"correspondingMessageId" : corrMessageId};
            NSDictionary *ack = @{@"ack": corrId};
            
            // send ack
            [socketIO sendJSON:ack];
        }
        
        PFInvocation* callback = [callbacks objectForKey:corrMessageId];
        if(callback){
            [callback invokeWithArgument:result];
            [callbacks removeObjectForKey:corrMessageId];
        }
    }
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet{
    NSLog(@"didSendMessage: %@", packet);    
}   


/**
 
 * Add a listener for the connect event
 */
+ (void) addListenerForConnectEvent:(NSObject*) target method:(SEL) selector{
    // Register any events that we are interested in.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:target selector:selector name:@"PFSocketConnected" object:nil];

}

/**
 * Add a listener for the ConnectResponse object, which is what signifies that we are read
 * to start sending traffic.
 */
+ (void) addListenerForReadyEvent:(NSObject*) target method:(SEL) selector{
    // Register any events that we are interested in.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:target selector:selector name:@"PFSocketReady" object:nil];
}



@end
