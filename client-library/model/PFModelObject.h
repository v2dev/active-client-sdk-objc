//
//  PFModelObject.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

#pragma mark - PFModelObject protocol
@protocol PFModelObject <Serializable>

@property (nonatomic, retain) NSString* ID;

@property(nonatomic) BOOL isShell;

- (void) overwriteWith:(id<PFModelObject>) object;

@optional
- (void) save;

@end

#pragma mark - PFModelObject class

@interface PFModelObject : NSObject;


#pragma mark PFModel protocol

@property (nonatomic, retain) NSString* ID;

@property(nonatomic) BOOL isShell;

- (void) overwriteWith:(id<PFModelObject>) object;

#pragma mark Serializable protocol
- (id) initFromDictionary:(NSDictionary*) dict;
- (NSMutableDictionary*) toDictionary:(BOOL)isShell;
- (NSString*) remoteClassName;

@end