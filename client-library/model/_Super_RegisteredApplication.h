//
//  _Super_RegisteredApplication.h
//  SocketConnect
//
//  Created by Jonathan Samples on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "Serializable.h"
@interface _Super_RegisteredApplication : NSObject <Serializable, PFModelObject>{
    NSString* ID;
    NSString* appName;
    bool isShell;
}

@property(nonatomic, retain) NSString* ID;
@property(nonatomic,retain) NSString* appName;
@property(nonatomic) bool isShell;


@end
