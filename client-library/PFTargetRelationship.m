//
//  PFTargetRelationship.m
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import "PFTargetRelationship.h"

@implementation PFTargetRelationship


- (id)initUnidirectionalWithInverseClassName:(NSString *)inverseClassName inversePropertyName:(NSString *)inversePropertyName{
    if ([super init]) {
        self.inverseClassName = inverseClassName;
        self.inversePropertyName = inversePropertyName;
        
    }
    return self;
}
@end
