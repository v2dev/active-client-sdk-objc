//
//  PFBindingTableViewCell.h
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import <UIKit/UITableView.h>
#import "PFObjectBinder.h"
@interface PFBindingTableViewCell : UITableViewCell
@property (nonatomic, strong) PFObjectBinder *objectBinder;
@end
