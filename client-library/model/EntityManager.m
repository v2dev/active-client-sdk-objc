//
//  EntityManager.m
//  SocketConnect
//
//  Created by Jonathan Samples on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityManager.h"
#import "PFModelObject.h"
#import "Utility.h"
#import "FindByIdRequest.h"
#import "PFSocketManager.h"
#import "PFClient.h"

static EntityManager* sharedInstance;

@implementation EntityManager

- (id) init{
    self = [super init];
    if(self){
        entityModel = [[NSMutableDictionary alloc] init];
        sharedInstance = self;
    }
    
    return self;
}

+ (EntityManager*) sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[EntityManager alloc] init];
    }
    
    return sharedInstance;
}

/**
 * Use this method to fetch a specific Object from the model cache.
 */
- (id<PFModelObject>) entityForClass:(NSString*) c andId:(NSString*)identifier{
    NSMutableDictionary* classDict = [entityModel objectForKey:c];
    id<PFModelObject> object = [classDict objectForKey:identifier];
    
    return object;
}


/**
 * Use this method to get entity objects in the model.  If the object passed in
 * doesn't yet exist in the model cache then cache it.
 */
- (id<PFModelObject>) getEntity:(id<PFModelObject>)entity{
    NSMutableDictionary* classDict = [entityModel objectForKey:[[entity class] description]];
    
    // If we don't have a dictionary for this class yet, then create one
    if(!classDict){
        classDict = [[NSMutableDictionary alloc] init];
        [entityModel setObject:classDict forKey:[[entity class] description]];
    }
    
    id<PFModelObject> old = [classDict objectForKey:[entity ID]];
    
    // If the new one is not a shell then overwrite the old with the new
    if(old && ![entity isShell]){
        [old overwriteWith:entity];
    }
    // If the entity is not cached yet, then cache it
    else if(!old){
        [classDict setValue:entity forKey:[entity ID]];
        
        //      I don't know if we need this or not.  Was using it to notify the controller logic that an object had entered the model cache.
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", [[entity class] description]];
        [nc postNotificationName:notificationName object:self];
    }

    old = [classDict objectForKey:[entity ID]];
    
    return old;
}

- (NSMutableDictionary*) dictionaryForClass:(NSString*) c{
    return [entityModel objectForKey:c];
}

- (id) deserializeObject:(id) obj{
    id <Serializable> result;
    if([obj isKindOfClass:[NSDictionary class]]){
        BOOL isShell = NO;

        NSString* className = [obj objectForKey:@"cn"];
        // className is used for shell objects, cn for non-shell objects
        if(!className){
            className = [obj objectForKey:@"className"];
            isShell = YES;
        }
        
        if(!className){
            NSLog(@"unable to deserialize object.  Could not find classname.");
            return nil;
        }
        
        Class c = NSClassFromString([Utility translateRemoteClassName:className]);
        result = [c alloc];
        result = [result initFromDictionary:obj];
        if ([result conformsToProtocol:@protocol(PFModelObject)]){
            ((id<PFModelObject>)result).isShell = isShell;
        }
        // If the object 
        if([result conformsToProtocol:@protocol(PFModelObject)]){
            result = (id<Serializable>) [self getEntity:(id<PFModelObject>)result];
        }
    }
    else if([obj isKindOfClass:[NSArray class]]){
        NSMutableArray* obArray = [[NSMutableArray alloc] init];
                    
        for(id o in obj){
            id deserializedObject = [self deserializeObject:o];
            if (deserializedObject) [obArray addObject:deserializedObject];
        }
        
        result = (id <Serializable>)obArray;
    }
    
    return result;
}

- (void) deleteObject:(id<PFModelObject>) modelObject{
    NSString *objectClass = [[modelObject class] description];
    NSMutableDictionary *dict = [self dictionaryForClass:objectClass];
    [dict removeObjectForKey:modelObject.ID];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString* notificationName = [NSString stringWithFormat:@"modelDidChange%@", objectClass];
    [nc postNotificationName:notificationName object:self];
    
}
- (void)updateObject:(id<PFModelObject>)modelObject{
    [PFClient sendPutRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:nil method:nil];
}

- (void)updateObject:(id<PFModelObject>)modelObject withCompletionTarget:(id) target method:(SEL) method{
    [PFClient sendPutRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:target method:method];
}

- (void)createObject:(id<PFModelObject>)modelObject{
    [PFClient sendCreateRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:nil method:nil];

}

- (void)createObject:(id<PFModelObject>)modelObject withCompletionTarget:(id) target method:(SEL) method{
    [PFClient sendCreateRequestWithClass:[modelObject remoteClassName] object:modelObject completionTarget:target method:method];
}

- (void) loadEntity:(id<PFModelObject>)entity{
    
    PFClient* ad = [PFClient sharedInstance];
    
    FindByIdRequest* req = [[FindByIdRequest alloc] init];
    req.theClassId = entity.ID;
    req.theClassName = [entity remoteClassName];
    req.clientId = ad.clientId;
    req.userId = ad.userId;

    [[PFSocketManager sharedInstance] sendEvent:@"findById" data:req callback:nil];
}
- (void) didreceiveDelete{
    
}
/**
 * We have a helper function for setting up listeners for types of events that the EntityManager will emit
 * Specifically, the entity manager will emit an even for every object that it gets with the event name: didReceive{className}
 */
//+ (void) addListenerForObjectType:(NSString*) className target:(NSObject*)target method:(SEL) selector{
//    // Register any events that we are interested in.
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        
//    [nc addObserver:target
//           selector:selector 
//               name:[NSString stringWithFormat:@"modelDidChange%@", className] 
//             object:[self sharedInstance]];
//
//}




@end
