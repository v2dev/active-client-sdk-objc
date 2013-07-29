//
//  JsonObject.m
//  Percero
//
//  Created by Jeff Wolski on 7/22/13.
//
//

#import "JsonObject.h"

@implementation JsonObject

@dynamic jsonData;
@dynamic nameOfClass;
@dynamic objectId;

@end

@implementation PFModelObject (JsonObject)

- (NSData *)jsonData;
{
    NSError *errorJSON = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary:self.isShell] options:NSJSONWritingPrettyPrinted error:&errorJSON];
    return jsonData;
}

@end
