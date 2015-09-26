//
//  AuthenticationResponse.h
//  Pods
//
//  Created by Bradley R Anderson on 9/25/15.
//
//

#import <Foundation/Foundation.h>
#import "PFModelObject.h"
#import "Serializable.h"
#import "EntityManager.h"
#import "UserToken.h"
#import "AuthResponse.h"

@interface AuthenticationResponse : AuthResponse <Serializable> {
  NSString* deviceId;
  BOOL isShell;
  UserToken *result;
}

@property(nonatomic, retain) NSString* deviceId;
@property(nonatomic) BOOL isShell;
@property(nonatomic, retain) UserToken *result;

@end
