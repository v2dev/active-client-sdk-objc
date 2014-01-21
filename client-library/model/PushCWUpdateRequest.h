//
//  PushCWUpdateRequest.h
//
//  Created by Jeff Wolski.
//

#import "SyncRequest.h"

@interface PushCWUpdateRequest : SyncRequest

@property(nonatomic, retain) NSString* theClassName;
@property(nonatomic, retain) NSString* theClassId;
@property(nonatomic, retain) NSString* fieldName;

@end
