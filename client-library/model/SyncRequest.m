//
//  SyncRequest.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncRequest.h"

@implementation SyncRequest
@synthesize token,clientId,userName,messageId,clientType,responseChannel;

- (id) init{
    self = [super init];
    if(self){
        token = @"";
        clientId = @"";
        userName = @"";
        messageId = @"";
        clientType = @"";
        responseChannel = @"";
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super init];
    if(self){
        token = [dict objectForKey:@"token"];
        clientId = [dict objectForKey:@"clientId"];
        userName = [dict objectForKey:@"userName"];
        messageId = [dict objectForKey:@"messageId"];
        clientType = [dict objectForKey:@"clientType"];
        responseChannel = [dict objectForKey:@"responseChannel"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:token forKey:@"token"];
        [dict setObject:clientId forKey:@"clientId"];
        [dict setObject:userName  forKey:@"userName"];
        [dict setObject:messageId  forKey:@"messageId"];
        [dict setObject:clientType  forKey:@"clientType"];
        [dict setObject:responseChannel  forKey:@"responseChannel"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.SyncRequest";
}


@end
