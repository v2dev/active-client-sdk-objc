//
//  AuthResponse.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthResponse.h"

@implementation AuthResponse
@synthesize clientId, correspondingMessageId, statusCode, message;

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        clientId = [dict valueForKey:@"clientId"];
        correspondingMessageId = [dict valueForKey:@"correspondingMessageId"];
        statusCode = [dict valueForKey:@"statusCode"];
        message = [dict valueForKey:@"message"];
    }
    
    return self;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.auth.vo.AuthResponse";
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:correspondingMessageId forKey:@"correspondingMessageId"];
        [dict setObject:clientId  forKey:@"clientId"];
        [dict setObject:statusCode  forKey:@"statusCode"];
        [dict setObject:message  forKey:@"message"];
    }
    
    return dict;
}


@end
