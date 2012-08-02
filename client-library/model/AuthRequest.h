//
//  AuthRequest.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface AuthRequest : NSObject <Serializable>{
    NSString* userId;
    NSString* token;
    NSString* clientType;
    NSString* clientId;
    NSString* messageId;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* token;
@property(nonatomic, retain) NSString* clientType;
@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* messageId;

@end
