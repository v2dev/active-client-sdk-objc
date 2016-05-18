//
//  PFModelObject.m
//  Percero
//
//  Created by Jeff Wolski on 3/22/13.
//

#import "PFModelObject.h"
#import "EntityManager.h"
#import "ClassIDPair.h"
#import "PFClient.h"
#import "Utility.h"
#import "PFPersistence.h"


static long long int PFMODEL_ALLOCATION_COUNT = 0;
static long long int PFMODEL_DEALOCATION_COUNT = 0;
static long long int PFMODEL_UPDATE_COUNT = 0;
static long long int PFMODEL_INFLATED_COUNT = 0;


void PF_PRINT_MODEL_STATS() {
    printf("Allocated: %lld\nInflated: %lld\nLiving: %lld\n",PFMODEL_ALLOCATION_COUNT, PFMODEL_UPDATE_COUNT, (PFMODEL_ALLOCATION_COUNT-PFMODEL_DEALOCATION_COUNT));
}

char * PF_MODEL_STATS() {
    static char str[512];
    sprintf(str, "PFModels Allocated: %lld Inflated: %lld Living: %lld ",PFMODEL_ALLOCATION_COUNT, PFMODEL_UPDATE_COUNT, (PFMODEL_ALLOCATION_COUNT-PFMODEL_DEALOCATION_COUNT));
    return str;
}

@implementation PFModelObject

@synthesize ID, isShell, isLoading;

- (void)overwriteWith:(id<PFModelObject>)object{
    // do nothing
    PFMODEL_UPDATE_COUNT++;
    
//    NSData *a = [NSJSONSerialization dataWithJSONObject:[self toDictionary:0] options:0 error:NULL];
//    NSData *b = [NSJSONSerialization dataWithJSONObject:[object toDictionary:0] options:0 error:NULL];
//    
//    if ([a isEqualToData:b]) {
//        NSLog(@"ERROR: Duplicate object from server");
//    }
}


- (id)initFromDictionary:(NSDictionary *)dict{
    PFMODEL_ALLOCATION_COUNT++;
	self = [super init];
    return self;
}

- (id)init {
    PFMODEL_ALLOCATION_COUNT++;
    self = [super init];
    return self;
}


- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    return dict;
}

- (NSString *)remoteClassName{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}
+ (NSString *)remoteClassName{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}
- (void)save{
    
    if (self.ID) {
        [[EntityManager sharedInstance] updateObject:self];
    } else {
        self.ID = [[NSUUID UUID] UUIDString];
        [[EntityManager sharedInstance] createObject:self];
    }
}

- (void)saveWithCompletionTarget:(id)target method:(SEL)method {
    if (self.ID) {
        [[EntityManager sharedInstance] updateObject:self withCompletionTarget:target method:method];
    } else {
        self.ID = [[NSUUID UUID] UUIDString];
        [[EntityManager sharedInstance] createObject:self withCompletionTarget:target method:method];
    }
}

- (void)requestUpdate{
    
        [PFPersistence sendFindByIdRequestWithRemoteClassName:self.remoteClassName objectId:self.ID callBackTarget:nil callbackMethod:nil];
}

- (void)delete{
	[[EntityManager sharedInstance] deleteObject:self];
}

- (void)restoreDeletedRelationships{
    
    // restore source relationship
    [[EntityManager sharedInstance] restoreDeletedRelationships:self];

    
}





- (void) getUniqueChangeWatcherWithFieldName:(NSString *) fieldName parameters:(NSArray *) parameters{
    if (!changeWatcherCache) {
        changeWatcherCache = [NSMutableDictionary new];
    }
    
    if ([changeWatcherCache objectForKey:fieldName]) {
        return;
    }
    
    else {
        [changeWatcherCache setObject:fieldName forKey:fieldName];
        NSLog(@"CHANGE WATCHER: %@ %@",self,fieldName);
        [PFClient sendPushCWRequestWithEntity:self
                                fieldName:fieldName
                               parameters:parameters
                                   target:nil
                                   method:nil];
    }
}




- (void) getChangeWatcherWithFieldName:(NSString *) fieldName parameters:(NSArray *) parameters{

    NSLog(@"CHANGE WATCHER: %@ %@",self,fieldName);
    [PFClient sendPushCWRequestWithEntity:self
                                fieldName:fieldName
                               parameters:parameters
                                   target:nil
                                   method:nil];
    
}

- (void) getChangeWatcherWithFieldName:(NSString *) fieldName parameters:(NSArray *) parameters callBackTarget:(NSObject*) target callbackMethod:(SEL) method{
    
    [PFClient sendPushCWRequestWithEntity:self
                                fieldName:fieldName
                               parameters:parameters
                                   target:target
                                   method:method];
    
}

+(void)requestServerSideDerivedCollectionWithRootObject:(id)rootObject
      changeWatcherFieldName:(NSString *)changeWatcherFieldName
                       param:(NSArray*)param
              callbackTarget:(id)callbackTarget
            callbackSelector:(SEL)callbackSelector{
    
    
    [rootObject getChangeWatcherWithFieldName:changeWatcherFieldName
                                   parameters:param
                               callBackTarget:callbackTarget
                               callbackMethod:callbackSelector];
}



-(ClassIDPair *)classIDPair{
    ClassIDPair *result = [[ClassIDPair alloc] init];
    
    result.className = self.remoteClassName;
    result.ID = ID;      
    return result;
}
+ (NSMutableArray *)all{
    NSString *className = [Utility translateRemoteClassName:[[self alloc] remoteClassName]];
    NSMutableDictionary *dict = [[EntityManager sharedInstance] dictionaryForClass:className];
    return [[dict allValues] mutableCopy];
}
+ (NSArray *)relationships {
    return @[];
}

-(NSString *) description {
  if ([self respondsToSelector:@selector(ID)]) {
    return [[super description] stringByAppendingString:[NSString stringWithFormat:@"ID: %@",self.ID]];
  }
  else {
    return [super description];
  }
}

-(void) dealloc {
    PFMODEL_DEALOCATION_COUNT++;
}

@end