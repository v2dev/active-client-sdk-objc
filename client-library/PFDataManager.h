//
//  PFDataManager.h
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import <Foundation/Foundation.h>

@interface PFDataManager : NSObject
+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)className objectId:(NSString*)id callBackTarget:(NSObject*) target callbackMethod:(SEL) selector;
+ (void) setup;
@end
