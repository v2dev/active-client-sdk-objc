//
//  AuthenticationResponse.m
//  Pods
//
//  Created by Bradley R Anderson on 9/25/15.
//
//

#import "AuthenticationResponse.h"

@implementation AuthenticationResponse
@synthesize deviceId, result, isShell;

- (id) initFromDictionary:(NSDictionary *)dict {
  self = [super initFromDictionary:dict];
  if(self){
    clientId = [dict valueForKey:@"clientId"];
    correspondingMessageId = [dict valueForKey:@"correspondingMessageId"];
    deviceId = [dict valueForKey:@"deviceId"];
    result = [[EntityManager sharedInstance] deserializeObject:[dict objectForKey:@"result"]];
  }
  
  return self;
}

- (NSString*) remoteClassName{
  return @"com.percero.agents.auth.vo.AuthenticationResponse";
}

- (NSDictionary*) toDictionary:(BOOL)_isShell{
  NSDictionary* dict = [super toDictionary:_isShell];
  [dict setValue:[self remoteClassName] forKey:@"cn"];
  [dict setValue:correspondingMessageId forKey:@"correspondingMessageId"];
  [dict setValue:clientId  forKey:@"clientId"];
  [dict setValue:deviceId  forKey:@"deviceId"];
  
 // if(!isShell){
 //   [dict setObject:correspondingMessageId forKey:@"correspondingMessageId"];
  //  [dict setObject:clientId  forKey:@"clientId"];
  //}
  
  return dict;
}


@end
