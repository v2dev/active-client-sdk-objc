//
//  JsonObject.h
//  Percero
//
//  Created by Jeff Wolski on 7/22/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JsonObject : NSManagedObject

@property (nonatomic, retain) NSData * jsonData;
@property (nonatomic, retain) NSString * nameOfClass;
@property (nonatomic, retain) NSString * objectId;

@end
