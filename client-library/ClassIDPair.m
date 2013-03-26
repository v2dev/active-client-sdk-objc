//
//  ClassIDPair.m
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "ClassIDPair.h"

@implementation ClassIDPair

- (id)initFromDictionary:(NSDictionary *)dict{
    self = [super initFromDictionary:dict];
    
    if (self) {
        
        self.ID = dict[@"ID"];
        self.className = dict[@"className"];
        if (!self.className) {
            self.className = dict[@"cn"];
        }
        self.properties = dict[@"properties"];
    }
    
    return self;
}

- (NSMutableDictionary *)toDictionary:(BOOL)isShell{
    
    NSMutableDictionary *dict = [super toDictionary:isShell];
    
    // Always set the ID and classname
	dict[@"ID"] = _ID;
    dict[@"properties"] = _properties;
	if(!isShell){
		// If we're not sending a shell then...
		dict[@"cn"] = [self remoteClassName];
        
        
    } else {
        
        dict[@"className"] = [self remoteClassName];

        
    }
    
    return dict;
}
@end
