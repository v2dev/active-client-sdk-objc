//
//  PFBindingTableViewCell.m
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import "PFBindingTableViewCell.h"

@implementation PFBindingTableViewCell
- (void)setAnchorObject:(id)anchorObject{


    [self willChangeValueForKey:@"anchorObject"];
    _anchorObject = anchorObject;
    [self didChangeValueForKey:@"anchorObject"];
    
    if ([self isMemberOfClass:[PFBindingTableViewCell class]]) {
        
        self.anchorObjectBinder.sourceObject = _anchorObject;
    }

    [self resetData];
}

- (PFObjectBinder *)anchorObjectBinder{
    if (!_anchorObjectBinder) {
        if ([self isMemberOfClass:[PFBindingTableViewCell class]]) {
            NSString *labelKeyPath = @"textLabel.text";
            _anchorObjectBinder = [[PFObjectBinder alloc] initWithTargetObject:self targetKeyPath:labelKeyPath sourceObject:self.anchorObject sourceKeyPath:_keyPathForAnchorObjectLabelString];
        } else {
            _anchorObjectBinder = [[PFObjectBinder alloc] init];
        }
    }
    return _anchorObjectBinder;
}

- (void) resetData {
    
    
    
    if ([self isMemberOfClass:[PFBindingTableViewCell class]]) {
       
        if (!self.textLabel.text) {
            self.textLabel.text = @".";
        }
    }
    


}
@end
