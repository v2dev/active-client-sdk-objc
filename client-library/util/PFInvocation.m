//
//  PFInvocation.m
//  SocketConnect
//
//  Created by Jonathan Samples on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFInvocation.h"

@implementation PFInvocation
@synthesize target, selector;

-(id) init{
    self = [super init];
    
    return self;
}

-(id) initWithTarget:(NSObject*)targetObject method:(SEL)selectorMethod{
    self = [self init];
    if(self){
        target = targetObject;
        selector = selectorMethod;
    }
    
    return self;
}


-(void) invoke{
    [target performSelector:selector];
}

-(void) invokeWithArgument:(NSObject*) obj{
    [target performSelector:selector withObject:obj];
}

@end
