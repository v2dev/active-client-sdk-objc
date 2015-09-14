//
//  PushDeleteResponse.h
//  ActiveStack
//
//  Created by Jeff Wolski on 3/13/13.
//
//

#import "SyncResponse.h"

@interface PushDeleteResponse : SyncResponse

@property (nonatomic, retain) NSMutableArray* result;

@end
