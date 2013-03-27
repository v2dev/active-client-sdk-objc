//
//  SyncRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface SyncRequest : NSObject <Serializable>{
    NSString* userId;
	NSString* token;
    NSString* clientType;
	NSString* clientId;
	NSString* deviceId;
	NSString* responseChannel;
	NSString* messageId;
	NSString* regAppKey;
	NSString* svcOauthKey;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSString* clientType;
@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* deviceId;
@property(nonatomic, retain) NSString* responseChannel;
@property(nonatomic, retain) NSString* messageId;
@property(nonatomic, retain) NSString* regAppKey;
@property(nonatomic, retain) NSString* svcOauthKey;
@property(nonatomic, assign) BOOL sendAck;

@end
