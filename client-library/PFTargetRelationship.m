//
//  PFTargetRelationship.m
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFTargetRelationship.h"

@implementation PFTargetRelationship


- (id)initUnidirectionalWithInverseClassName:(NSString *)inverseClassName inversePropertyName:(NSString *)inversePropertyName isRequired:(BOOL)isRequired{
    self = [super init];
    if (self) {
        self.inverseClassName = inverseClassName;
        self.inversePropertyName = inversePropertyName;
        
        _isRequired = isRequired;
    }
    return self;
}

- (id)initBidirectionalWithPropertyName:(NSString *)propertyName inverseClassName:(NSString *)inverseClassName inversePropertyName:(NSString *)inversePropertyName isRequired:(BOOL)isRequired{
    self = [super init];
    if (self) {
        
        self.propertyName = propertyName;
        self.inverseClassName = inverseClassName;
        self.inversePropertyName = inversePropertyName;
        
        _isRequired = isRequired;
    }
    return self;

}

- (NSString *)description{
    
    NSString *result = [super description];
    
    result = [NSString stringWithFormat:@"%@: self.%@ <- (%@ *) %@",result, self.propertyName, self.inverseClassName, self.inversePropertyName];
    
    return result;
}
@end
