//
//  PFArraysBinder.h
//  Percero
//
//  Created by Jeff Wolski on 6/11/13.
//
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"

@protocol PFArraysBinderDelegate <NSObject>



@end

@interface PFArraysBinder : NSObject
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) PFModelObject *dataObject;
@property (nonatomic, strong) NSString *keypath1;
@property (nonatomic, strong) NSString *keypath2;

- (id) initWithDataObject:(PFModelObject *) dataObject keyPath:(NSString *) keypath;
- (id) initWithDataObject:(PFModelObject *) dataObject keyPath1:(NSString *) keypath1 keyPath2:(NSString *) keypath2;

@end
