//
//  PutRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/14/13.
//
//

#import "SyncRequest.h"
#import "PFModelObject.h"

@interface PutRequest : SyncRequest

@property id <PFModelObject> theObject;
@property long putTimestamp;
@property NSString* transId;

@end
