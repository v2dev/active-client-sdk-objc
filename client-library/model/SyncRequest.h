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
    NSString* userName;
	NSString* token;
    NSString* clientType;
	NSString* clientId;
	NSString* responseChannel;
	NSString* messageId;
}

@property(nonatomic, retain) NSString* userName;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSString* clientType;
@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* responseChannel;
@property(nonatomic, retain) NSString* messageId;

@end
