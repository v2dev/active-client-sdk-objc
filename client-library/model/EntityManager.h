//
//  EntityManager.h
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"

@interface EntityManager : NSObject{
    NSMutableDictionary* entityModel;
}

+ (EntityManager*) sharedInstance;

- (id<PFModelObject>) entityForClass:(NSString*) c andId:(NSString*)identifier;
- (id<PFModelObject>) getEntity:(id<PFModelObject>)entity;
- (void) loadEntity:(id<PFModelObject>)entity;
- (NSMutableDictionary*) dictionaryForClass:(NSString*) c;
- (id) deserializeObject:(id) ob;
+ (void) addListenerForObjectType:(NSString*) className target:(NSObject*)target method:(SEL) selector;

@end
