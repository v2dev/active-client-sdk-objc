//
//  PFBindingTableViewCell.h
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import <UIKit/UIKit.h>
#import "PFObjectBinder.h"
@interface PFBindingTableViewCell : UITableViewCell
@property (nonatomic, weak) id anchorObject;
@property (nonatomic, strong) NSString *keyPathForAnchorObjectLabelString;
@property (nonatomic, strong) PFObjectBinder *anchorObjectBinder;
- (void) resetData;

@end
