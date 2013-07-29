//
//  PFPersistence.m
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import "PFPersistence.h"
#import "FindByIdRequest.h"
#import "PFClient.h"
#import "PFInvocation.h"
#import "PFSocketManager.h"
#import <UIKit/UIKit.h>
#import "JsonObject.h"



@interface PFPersistence ()

@property (nonatomic, strong) UIManagedDocument *document;
+ (PFPersistence *) sharedInstance;

@end

static PFPersistence *_sharedInstance;

@implementation PFPersistence

NSString *entityName = @"JsonObject";

+ (void)setup {
    [self sharedInstance];
}
+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)className objectId:(NSString*)id callBackTarget:(NSObject*) target callbackMethod:(SEL) selector{
    FindByIdRequest* request = [[FindByIdRequest alloc] init];
    [request setClientId:[PFClient sharedInstance].clientId];
    [request setToken:[PFClient sharedInstance].token];
    [request setUserId:[PFClient sharedInstance].userId];
    
    [request setTheClassName:className];
    [request setTheClassId:id];
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"findById" data:request callback:callback];
}
- (void) documentIsReady{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    //
}
- (id) init {
    
    if (self = [super init]) {
        NSString *documentName = @"MyDocument.md";
       
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:documentName];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                if (success) [self documentIsReady];
                if (!success) NSLog(@"couldn’t open document at %@", url);
            }]; } else {
                [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                       completionHandler:^(BOOL success) {
                           if (success) [self documentIsReady];
                           if (!success) NSLog(@"couldn’t create document at %@", url);
                       }];
            }
    }
    
    return self;
}
+ (NSArray *) findObjectsWithRemoteClassName:(NSString *) remoteClassName objectID:(NSString *) objectID{
    NSArray *result = nil;
    
    PFPersistence *dataManager = [self sharedInstance];
    NSManagedObjectContext *moc = dataManager.document.managedObjectContext;
//    NSDictionary *entities = dataManager.document.managedObjectModel.entitiesByName;
//    DLog(@"entities:%@",entities);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName]; request.fetchBatchSize = 20;
    
    NSPredicate *predicateNameOfClass = [NSPredicate predicateWithFormat:@"nameOfClass = %@", remoteClassName];
    NSPredicate *predicateObjectId = [NSPredicate predicateWithFormat:@"objectId = %@", objectID];
    NSPredicate *predicateCompound = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateNameOfClass, predicateObjectId]];
    request.predicate = predicateCompound;
    
    NSError *errorFetchRequest;
    result = [moc executeFetchRequest:request error:&errorFetchRequest];

    return result;
}


+ (void)addObject:(PFModelObject *) object
{
    if (![object isKindOfClass:[PFModelObject class]]) {
        return;
    }
    
    NSArray *storedObject = [self findObjectsWithRemoteClassName:object.remoteClassName objectID:object.ID];
    if (storedObject && storedObject.count) {
        // if the object already exists, update the jsonData
        NSAssert(storedObject.count == 1, @"Fetch should have returned 1 object instead of %d", storedObject.count);
        JsonObject *existingObject = storedObject[0];
        NSData *objectJasonData = object.jsonData;
        if (![objectJasonData isEqualToData:existingObject.jsonData]) {
            existingObject.jsonData = objectJasonData;
        }
        
    } else {
        // if the object does not yet exist, create a new one
        PFPersistence *dataManager = [self sharedInstance];
        NSManagedObjectContext *moc = dataManager.document.managedObjectContext;

        JsonObject *newObject = nil;

        newObject = [NSEntityDescription
                     insertNewObjectForEntityForName:entityName
                     inManagedObjectContext:moc];
        newObject.objectId = object.ID;
        newObject.nameOfClass = object.remoteClassName;
        NSData *jsonData;
        jsonData = object.jsonData;
        newObject.jsonData = jsonData;
        NSLog(@"newObject:%@", newObject);
        
    }
}

#pragma mark singleton

+ (PFPersistence *) sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (id) copyWithZone:(NSZone *) zone{
    return self;
}

@end
