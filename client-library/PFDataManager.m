//
//  PFDataManager.m
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import "PFDataManager.h"
#import "FindByIdRequest.h"
#import "PFClient.h"
#import "PFInvocation.h"
#import "PFSocketManager.h"

@implementation PFDataManager


+ (void) sendGetByIdRequest:(NSString*)className id:(NSString*)id target:(NSObject*) target method:(SEL) selector{
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

@end
