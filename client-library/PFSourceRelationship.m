//
//  PFSourceRelationship.m
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFSourceRelationship.h"

@implementation PFSourceRelationship

- (id)initBidirectionalWithPropertyName:(NSString *)propertyName
                       inverseClassName:(NSString *)inverseClassName
                    inversePropertyName:(NSString *)inversePropertyName{
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
        self.inverseClassName = inverseClassName;
        self.inversePropertyName = inversePropertyName;
    }
    return self;
}

- (id)initUnidirectionalWithPropertyName:(NSString *)propertyName{
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
    }
    return self;
}

@end
