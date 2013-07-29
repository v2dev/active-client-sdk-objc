//
//  PFPersistence.h
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import <Foundation/Foundation.h>

@interface PFPersistence : NSObject

+ (void)addObject:(id) object;

+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)remoteClassName objectId:(NSString*)objectId callBackTarget:(NSObject*) target callbackMethod:(SEL) selector;
+ (void) setup;
@end
