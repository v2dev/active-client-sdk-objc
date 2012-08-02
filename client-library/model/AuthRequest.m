//
//  AuthRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthRequest.h"

@implementation AuthRequest
@synthesize clientId, token, userId, messageId, clientType;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];

    if(self){
        clientId = [dict valueForKey:@"clientId"];
        token = [dict valueForKey:@"token"];
        userId = [dict valueForKey:@"userId"];
        messageId = [dict valueForKey:@"messageId"];
        clientType = [dict valueForKey:@"clientType"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL) isShell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    [dict setObject:clientId forKey:@"clientId"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:messageId  forKey:@"messageId"];
    [dict setObject:clientType  forKey:@"clientType"];
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthRequest";
}

@end
