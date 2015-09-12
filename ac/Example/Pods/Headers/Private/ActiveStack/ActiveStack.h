//
//  ActiveStack.h
//  Pods
//
//  Created by Vimbrij on 9/6/15.
//
//

#import <Foundation/Foundation.h>

#import <ActiveStack/PFClient.h>
#import <ActiveStack/PFBindingTableViewCell.h>
#import <ActiveStack/EntityManager.h>
#import <ActiveStack/PFArraysBinder.h>
#import <ActiveStack/Serializable.h>
#import <ActiveStack/PFModelObject.h>
#import <ActiveStack/ServiceApplicationOAuth.h>
#import <ActiveStack/ServiceApplication.h>
#import <ActiveStack/ServiceProvider.h>
#import <ActiveStack/RegisteredApplication.h>
#import <ActiveStack/EnvConfig.h>
#import <ActiveStack/IUserAnchor.h>
#import <ActiveStack/IUserRole.h>

@interface ActiveStack : NSObject

+ (NSString *)welcomeMessage;

@end
