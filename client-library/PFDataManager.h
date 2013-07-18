//
//  PFDataManager.h
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import <Foundation/Foundation.h>

@interface PFDataManager : NSObject
+ (void) sendFindByIdRequest:(NSString*)className id:(NSString*)id target:(NSObject*) target method:(SEL) selector;

@end
