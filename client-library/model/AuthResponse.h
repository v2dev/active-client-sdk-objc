//
//  AuthResponse.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface AuthResponse : NSObject <Serializable>{
    NSString* clientId;
	NSString* correspondingMessageId;
    NSNumber* statusCode;
    NSString* message;
}

@property(nonatomic, retain) NSString* clientId;
@property(nonatomic, retain) NSString* correspondingMessageId;
@property(nonatomic, retain) NSNumber* statusCode;
@property(nonatomic, retain) NSString* message;


@end
