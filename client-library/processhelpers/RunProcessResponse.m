//
//  ProcessHelperResponse.m
//  Pods
//
//  Created by Nikish Parikh on 6/27/16.
//
//
#import "RunProcessResponse.h"
#import "EntityManager.h"

@implementation RunProcessResponse

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        
        _result = [dict[@"result"] boolValue];
        
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    dict[@"result"] = @(_result);
    
    return dict;
}

- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.RunProcessRequest";
    
}
@end
