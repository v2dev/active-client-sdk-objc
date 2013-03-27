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

@property(nonatomic) BOOL isLoading;
+ (NSArray *) relationships;
- (void) save;
@end

#pragma mark - PFModelObject class

@interface PFModelObject : NSObject{

    // These are transient but needed for client side sync stuff
	BOOL isShell;
	BOOL isLoading;
    NSString * ID;
};


#pragma mark PFModel protocol

@property (nonatomic, retain) NSString* ID;

@property(nonatomic) BOOL isShell;
@property(nonatomic) BOOL isLoading;

- (void) overwriteWith:(id<PFModelObject>) object;

#pragma mark Serializable protocol
- (id) initFromDictionary:(NSDictionary*) dict;
- (NSMutableDictionary*) toDictionary:(BOOL)isShell;
- (NSString*) remoteClassName;


+ (NSArray *) relationships;
@end