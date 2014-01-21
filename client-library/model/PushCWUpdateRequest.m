//
//  PushCWUpdateRequest.m
//
//  Created by Jeff Wolski.
//

#import "PushCWUpdateRequest.h"

@implementation PushCWUpdateRequest

- (id) init{
    self = [super init];
    if(self){
        DLog(@"");
        _theClassId = @"";
        _theClassName = @"";
        _fieldName = nil;
    }
    
    return self;
}

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _theClassId = [dict objectForKey:@"theClassId"];
        _theClassName = [dict objectForKey:@"theClassName"];
        _fieldName = [dict objectForKey:@"fieldName"];
    }
    
    return self;
}

- (NSMutableDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:_theClassId  forKey:@"theClassId"];
        [dict setObject:_theClassName  forKey:@"theClassName"];
        [dict setObject:_fieldName forKey:@"fieldName"];
    }
    
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PushCWUpdateRequest";
}

- (NSString *) eventName {
    return @"pushCWUpdate";
}


@end
