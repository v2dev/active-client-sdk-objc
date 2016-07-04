//
//  ProcessHelperRequest.h
//  Pods
//
//  Created by Nikish Parikh on 6/27/16.
//
//
#import <Foundation/Foundation.h>
#import "SyncRequest.h"
#import "PFModelObject.h"

@interface RunProcessRequest : SyncRequest
{
    NSString* queryName;
    NSMutableArray* queryArguments;
}

@property(nonatomic, retain) NSString* queryName;
@property(nonatomic, retain) NSArray* queryArguments;

@end
