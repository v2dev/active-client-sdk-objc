//
//  PFModelObject.m
//  Percero
//
//  Created by Jeff Wolski on 3/22/13.
//

#import "PFModelObject.h"

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

+ (NSArray *)relationships {
    return @[];
}
@end