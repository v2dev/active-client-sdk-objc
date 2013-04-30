//
//  PFObjectBinder.m
//  iOS Mobile Companion
//
//  Created by Jeff Wolski on 4/26/13.
//  Copyright (c) 2013 John Coumerilh. All rights reserved.
//

#import "PFObjectBinder.h"
#import "PFModelObject.h"

@implementation PFObjectBinder

- (void) updateTargetObject{
    
    if (_sourceObject && _sourceKeyPath && _targetObject && _targetKeyPath) {
        
        id sourceValue = [self.sourceObject valueForKeyPath:self.sourceKeyPath];
        [self.targetObject setValue:sourceValue forKeyPath:self.targetKeyPath];

    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    [self updateTargetObject];
    
}
- (void)setTargetObject:(id)targetObject{
    
    [self unregisterKvo];
    _targetObject = targetObject;
    [self registerKvo];
    
}

- (void)setTargetKeyPath:(NSString *)targetKeyPath{
    
    [self unregisterKvo];
    _targetKeyPath = targetKeyPath;
    [self registerKvo];
    
}

- (void)setSourceObject:(id)sourceObject{
    
    [self unregisterKvo];
    _sourceObject = sourceObject;
    [self registerKvo];
    
}

- (void)setSourceKeyPath:(NSString *)sourceKeyPath{
    
    [self unregisterKvo];
    _sourceKeyPath = sourceKeyPath;
    [self registerKvo];
    
}




- (PFObjectBinder *)initWithTargetObject:(id)targetObject targetKeyPath:(NSString *)targetKeyPath sourceObject:(id)sourceObject sourceKeyPath:(NSString *)sourceKeyPath{
    
    if (self = [self init]) {
        
        _targetObject = targetObject;
        _targetKeyPath = targetKeyPath;
        _sourceObject = sourceObject;
        _sourceKeyPath = sourceKeyPath;
        
        [self registerKvo];

    }
    
    return self;
}

- (void) registerKvo{
    
    if (_sourceObject && _sourceKeyPath) {
        if ([_sourceObject respondsToSelector:@selector(isSubclassOfClass:)]) {
            if ([_sourceObject isSubclassOfClass:[PFModelObject class]]) {
                // source object is a PFModelObject subclass
                NSString *notificationName = [NSString stringWithFormat:@"modelDidChange%@",[[_sourceObject class] description]];
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc addObserver:self selector:@selector(updateTargetObject) name:notificationName object:nil];
                
            } else {
                // 
            }
        } else {
            // source object is an instance
            [_sourceObject addObserver:self forKeyPath:_sourceKeyPath options:0 context:nil];
        }
    }
    
    [self updateTargetObject];
    
}

- (void)unregisterKvo{
    if (_sourceObject && _sourceKeyPath) {
        [_sourceObject removeObserver:self forKeyPath:_sourceKeyPath context:nil];
    }
}

- (void)dealloc{
    [self unregisterKvo];
}

@end
