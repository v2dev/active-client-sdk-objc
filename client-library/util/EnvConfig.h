//
//  EnvConfig.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvConfig : NSObject{
    NSDictionary* configs;
}

+ (EnvConfig*) sharedInstance;
- (NSString*) getEnvProperty:(NSString*) propName;

@end
