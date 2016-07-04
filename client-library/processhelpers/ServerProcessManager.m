//
//  ServerProcessManager.m
//  Pods
//
//  Created by Nikish Parikh on 6/27/16.
//
//

#import "ServerProcessManager.h"
#import "PFClient.h"
// The singleton
static ServerProcessManager* _sharedInstance;


@implementation ServerProcessManager


+ (ServerProcessManager*) sharedInstance{
    if(!_sharedInstance){
        // Try to load the saved instance
        _sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:@"serverprocessmanager"];
        if(!_sharedInstance){
            _sharedInstance = [[ServerProcessManager alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (void) runProcessWith:(NSString *) name parameters:(NSArray *) args  delegate:(id<ServerProcessManagerDelegate>)delegate{
    [PFClient sendRunProcessWithName:name parameters:args target:delegate method:@selector(onProcessResponse)];
}

@end
