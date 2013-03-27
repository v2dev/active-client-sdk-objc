//
//  ClassIDPair.h
//  Percero
//
//  Created by Jeff Wolski on 3/25/13.
//
//

#import "SyncRequest.h"

@interface ClassIDPair : SyncRequest <Serializable>

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSDictionary *properties;

@end
