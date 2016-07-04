//
//  ProcessHelperRequest.m
//  Pods
//
//  Created by Nikish Parikh on 6/27/16.
//
//

#import "RunProcessRequest.h"

@implementation RunProcessRequest


@synthesize queryName, queryArguments;

- (id) init{
    self = [super init];
    if(self){
        //        DLog(@"");
        queryName = @"";
        queryArguments = nil;
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        queryName = [dict objectForKey:@"queryName"];
        queryArguments = [dict objectForKey:@"queryArguments"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:queryName  forKey:@"queryName"];
        if (queryArguments)[dict setObject:queryArguments forKey:@"queryArguments"];
        
    }
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.RunProcessRequest";
}


- (NSString *) eventName {
    return @"runProcess";
}

@end