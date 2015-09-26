//
//  AuthenticateUsernamePasswordPairAuthRequest.m
//
//
//  Created by Bradley R Anderson on 9/22/15.
//
//

#import "AuthenticationRequest.h"

@implementation AuthenticationRequest
@synthesize credential, authProvider, messageId, deviceId;

- (id) initFromDictionary:(NSDictionary *)dict{
  self = [super init];
  
  if(self){
    credential = [dict valueForKey:@"credential"];
    authProvider = [dict valueForKey:@"authProvider"];
    messageId = [dict valueForKey:@"messageId"];
    deviceId = [dict valueForKey:@"deviceId"];
  }
  
  return self;
}

- (NSDictionary*) toDictionary:(BOOL) isShell{
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setObject:[self remoteClassName] forKey:@"cn"];
  [dict setObject:credential forKey:@"credential"];
  [dict setObject:authProvider forKey:@"authProvider"];
  [dict setObject:messageId forKey:@"messageId"];
  [dict setObject:@"NP" forKey:@"clientType"];
  [dict setObject:@"AAA" forKey:@"clientId"];
  [dict setObject:@"" forKey:@"token"];
  [dict setObject:@"" forKey:@"userId"];
  [dict setObject:@"" forKey:@"regAppKey"];
  [dict setObject:deviceId forKey:@"deviceId"];
 
  
  return dict;
}

- (void) overwriteWith:(id<PFModelObject>) object {
  //TODO
}


- (NSString*) remoteClassName{
  return @"com.percero.agents.auth.vo.AuthenticationRequest";
}

@end
