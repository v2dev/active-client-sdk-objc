//
//  PushCWUpdateResponse.h
//
//  Created by Jeff Wolski
//

#import "SyncResponse.h"
#import "PFModelObject.h"

@interface PushCWUpdateResponse : SyncResponse<Serializable>

@property(nonatomic, retain) NSString* theClassName;
@property(nonatomic, retain) NSString* theClassId;
@property(nonatomic, retain) NSString* fieldName;

@property(nonatomic, retain) id result;

@end