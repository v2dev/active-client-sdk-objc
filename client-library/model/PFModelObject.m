//
//  PFModelObject.m
//  Percero
//
//  Created by Jeff Wolski on 3/22/13.
//

#import "PFModelObject.h"

@implementation PFModelObject

@synthesize ID, isShell;

- (void)overwriteWith:(id<PFModelObject>)object{
    DLog(@"This should be implemented by the subclasses");
}

- (id)initFromDictionary:(NSDictionary *)dict{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}


- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}

- (NSString *)remoteClassName{
    DLog(@"This should be implemented by the subclasses");
    return nil;
}
@end