//
//  PFDataManager.m
//  Percero
//
//  Created by Jeff Wolski on 6/14/13.
//
//

#import "PFDataManager.h"
#import "FindByIdRequest.h"
#import "PFClient.h"
#import "PFInvocation.h"
#import "PFSocketManager.h"
#import <UIKit/UIKit.h>
@interface PFDataManager ()

@property (nonatomic, strong) UIManagedDocument *document;
+ (PFDataManager *) sharedInstance;

@end

static PFDataManager *_sharedInstance;

@implementation PFDataManager
+ (void)setup {
    [self sharedInstance];
}
+ (void) sendFindByIdRequestWithRemoteClassName:(NSString*)className objectId:(NSString*)id callBackTarget:(NSObject*) target callbackMethod:(SEL) selector{
    FindByIdRequest* request = [[FindByIdRequest alloc] init];
    [request setClientId:[PFClient sharedInstance].clientId];
    [request setToken:[PFClient sharedInstance].token];
    [request setUserId:[PFClient sharedInstance].userId];
    
    [request setTheClassName:className];
    [request setTheClassId:id];
    
    PFInvocation* callback = nil;
    if(target && selector)
        callback = [[PFInvocation alloc] initWithTarget:target method:selector];
    
    [[PFSocketManager sharedInstance] sendEvent:@"findById" data:request callback:callback];
}
- (void) documentIsReady{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //
}
- (id) init {
    
    if (self = [super init]) {
        NSString *documentName = @"MyDocument.md";
       
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:documentName];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                if (success) [self documentIsReady];
                if (!success) NSLog(@"couldn’t open document at %@", url);
            }]; } else {
                [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                       completionHandler:^(BOOL success) {
                           if (success) [self documentIsReady];
                           if (!success) NSLog(@"couldn’t create document at %@", url);
                       }];
            }
    }
    
    return self;
}

#pragma mark singleton

+ (PFDataManager *) sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (id) copyWithZone:(NSZone *) zone{
    return self;
}

@end
