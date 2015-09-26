//
//  AuthenticateUsernamePasswordPairAuthRequest.h
//  
//
//  Created by Bradley R Anderson on 9/22/15.
//
//

#import "AuthRequest.h"
#import "PFModelObject.h"
#import "Serializable.h"

@interface AuthenticationRequest : NSObject <Serializable> {
  NSString* credential;
  NSString* authProvider;
  NSString* messageId;
  NSString* deviceId;
}

@property(nonatomic, strong) NSString* credential;
@property(nonatomic, strong) NSString* authProvider;
@property(nonatomic, strong) NSString* messageId;
@property(nonatomic, strong) NSString* deviceId;

@end
