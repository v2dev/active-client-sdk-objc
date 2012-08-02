//
//  PFModelObject.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@protocol PFModelObject <Serializable>

@property (nonatomic, retain) NSString* ID;

- (void) overwriteWith:(id<PFModelObject>) object;
- (BOOL) isShell;

@end
