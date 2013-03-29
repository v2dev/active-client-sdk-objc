//
//  PFModelObject.m
//  Percero
//
//  Created by Jeff Wolski on 3/22/13.
//

#import "PFModelObject.h"
#import "EntityManager.h"
#import "ClassIDPair.h"

@implementation PFModelObject

@synthesize ID, isShell, isLoading;

- (void)overwriteWith:(id<PFModelObject>)object{
    // do nothing
}

- (id)initFromDictionary:(NSDictionary *)dict{
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

- (void)save{
    
    if (self.ID) {
        [[EntityManager sharedInstance] updateObject:self];
    } else {
        self.ID = [[NSUUID UUID] UUIDString];
        [[EntityManager sharedInstance] createObject:self];
    }
}

- (void)delete{
	[[EntityManager sharedInstance] deleteObject:self];
}

-(ClassIDPair *)classIDPair{
    ClassIDPair *result = [[ClassIDPair alloc] init];
    
    result.className = self.remoteClassName;
    result.ID = ID;      
    return result;
}

+ (NSArray *)relationships {
    return @[];
}
@end