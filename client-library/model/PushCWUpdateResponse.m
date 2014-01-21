//
//  PushCWUpdateResponse.m
//
//  Created by Jeff Wolski.
//

#import "PushCWUpdateResponse.h"
#import "EntityManager.h"

@implementation PushCWUpdateResponse

- (id) initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    if(self){
        _theClassId = [dict objectForKey:@"theClassId"];
        _theClassName = [dict objectForKey:@"theClassName"];
        _fieldName = [dict objectForKey:@"fieldName"];

        _result =[dict objectForKey:@"result"];
    }
    
    return self;
}

- (NSDictionary*) toDictionary:(BOOL)isShell{
    NSMutableDictionary* dict = [super toDictionary:NO];
    [dict setObject:[self remoteClassName] forKey:@"cn"];
    
    if(!isShell){
        [dict setObject:_theClassId  forKey:@"theClassId"];
        [dict setObject:_theClassName  forKey:@"theClassName"];
        [dict setObject:_fieldName forKey:@"fieldName"];
        [dict setObject:_result forKey:@"result"];

    }
    return dict;
}


- (NSString*) remoteClassName{
    return @"com.percero.agents.sync.vo.PushCWUpdateResponse";
}


@end
