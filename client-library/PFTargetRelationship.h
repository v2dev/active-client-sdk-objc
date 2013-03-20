//
//  PFTargetRelationship.h
//  Percero
//
//  Created by Jeff Wolski on 3/20/13.
//
//

#import <Foundation/Foundation.h>

#import "PFRelationship.h"

@interface PFTargetRelationship : PFRelationship

@property (nonatomic, assign) BOOL isRequired;
@property (nonatomic, assign) BOOL isToMany;

- initUnidirectionalWithInverseClassName:(NSString *) inverseClassName
                     inversePropertyName:(NSString *) inversePropertyName;
- initBidirectionalWithPropertyName:(NSString *) propertyName
                   inverseClassName:(NSString *) inverseClassName
                inversePropertyName:(NSString *) inversePropertyName;

@end
