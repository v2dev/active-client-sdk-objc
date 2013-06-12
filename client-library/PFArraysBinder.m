//
//  PFArraysBinder.m
//  Percero
//
//  Created by Jeff Wolski on 6/11/13.
//
//

#import "PFArraysBinder.h"
@interface PFModelObject (PFArrayBinder)

- (NSString *)arraysBinderChildrenKey ;
@end

@interface PFArraysBinder ()

@property (nonatomic, strong) NSMutableDictionary *children;

@end

@implementation PFArraysBinder
- (NSMutableDictionary *)children{
    if (!_children) {
        _children = [[NSMutableDictionary alloc] init];
    }
    return _children;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    DLog(@"\n\nchange:%@", change);
    if (self.delegate) {
        NSString *extendedKeypath = [NSString stringWithFormat:@"%@.%@",self.keypath1, keyPath];

        [self.delegate observeValueForKeyPath:extendedKeypath ofObject:object change:change context:context];
    }
}


- (void) bindToArray1{

    [self.dataObject addObserver:self forKeyPath:self.keypath1 options:0 context:nil];
    
}
- (void) buildArrayBinder2 {
    NSArray *dataArray = [self.dataObject valueForKeyPath:self.keypath1];
    for (PFModelObject *object in dataArray) {
        NSString *newKey = [object arraysBinderChildrenKey];
        PFArraysBinder *newArrayBinder = [[PFArraysBinder alloc] initWithDataObject:object keyPath:self.keypath2];
        newArrayBinder.delegate = self;
        [self.children setObject:newArrayBinder forKey:newKey];
    }
}

- (id)initWithDataObject:(PFModelObject *)dataObject keyPath:(NSString *)keypath
{
    if ([self init]){
        _dataObject = dataObject;
        _keypath1 = keypath;
        
        [self bindToArray1];
        
        
    }
    return self;
}

- (id)initWithDataObject:(PFModelObject *)dataObject keyPath1:(NSString *)keypath1 keyPath2:(NSString *)keypath2
{
    if ([self init]){
        _dataObject = dataObject;
        _keypath1 = keypath1;
        _keypath2 = keypath2;
        
        [self bindToArray1];
        [self buildArrayBinder2];
        
    }
    return self;
}

@end


@implementation PFModelObject (PFArrayBinder)

- (NSString *)arraysBinderChildrenKey{
    return  [NSString stringWithFormat:@"%@-%@",self.class,self.ID];
}


@end
