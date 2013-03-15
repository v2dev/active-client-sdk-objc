//
//  PutRequest.h
//  Percero
//
//  Created by Jeff Wolski on 3/14/13.
//
//

#import "SyncResponse.h"
#import "PFModelObject.h"

@interface PutRequest : SyncResponse

@property id <PFModelObject> theObject;
@property long putTimestamp;
@property NSString* transId;

@end
