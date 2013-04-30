//
//  PFTableSectionData.h
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PFTableSectionDataSectionStyleSectionHeader,
    PFTableSectionDataSectionStyleCell,
} PFTableSectionDataSectionStyle;


@interface PFTableSectionData : NSObject <UITableViewDataSource>
@property (weak, nonatomic) id anchorObject;
@property (strong, nonatomic) NSString *keyPathForSectionsArray;
@property (strong, nonatomic) NSString *keyPathForCellsArray;

@property (strong, nonatomic) NSString *keyPathForSectionLabelText;
@property (strong, nonatomic) NSString *keyPathForCellLabelText;
@property (assign, nonatomic) PFTableSectionDataSectionStyle sectionStyle;

+ (PFTableSectionData *)TableSectionDataWithAnchorObject:(id) anchorObject
                                 keyPathForSectionsArray:(NSString *) keyPathForSectionsArray
                                    keyPathForCellsArray:(NSString *) keyPathForCellsArray
                              keyPathForSectionLabelText:(NSString *) keyPathForSectionLabelText
                              keyPathForCellLabelText:(NSString *) keyPathForCellLabelText
                                            sectionStyle:(PFTableSectionDataSectionStyle) sectionStyle;
@end
