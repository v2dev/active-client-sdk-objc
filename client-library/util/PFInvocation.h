//
//  PFInvocation.h
//  SocketConnect
//
//  Created by Jonathan Samples on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFInvocation : NSObject{
    NSObject* target;
    SEL selector;
}

@property(nonatomic, retain) NSObject* target;
@property(nonatomic) SEL selector;

-(id) initWithTarget:(NSObject*)targetObject method:(SEL)selectorMethod;
-(void) invoke;
-(void) invokeWithArgument:(NSObject*) obj;

@end
