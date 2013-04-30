//
//  PFTableViewDataSource.m
//  Percero
//
//  Created by Jeff Wolski on 4/30/13.
//
//

#import "PFTableViewDataSource.h"

@interface PFTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray *rowBindings;

@end


@implementation PFTableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    id sectionObject = sectionsArray[indexPath.section];
    NSArray *cellsArray = [sectionObject valueForKeyPath:_keyPathForCellsArray];
    id cellObject = cellsArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_keyPathForCellsArray];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_keyPathForCellsArray];
    }
    
    cell.textLabel.text = [cellObject valueForKeyPath:_keyPathForCellLabelText];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    id sectionObject = sectionsArray[section];
    NSString *sectionTitle = [sectionObject valueForKeyPath:_keyPathForSectionLabelText];
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    id sectionObject = sectionsArray[section];
    NSArray *cellsArray = [sectionObject valueForKeyPath:_keyPathForCellsArray];
    NSInteger numberOfCells = cellsArray.count;
    return numberOfCells;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *sectionsArray = [_anchorObject valueForKeyPath:_keyPathForSectionsArray];
    NSInteger numberOfSections = sectionsArray.count;
    return numberOfSections;
}
#pragma mark
- (id) initWithAnchorObject:(id)anchorObject
    keyPathForSectionsArray:(NSString *)keyPathForSectionsArray
       keyPathForCellsArray:(NSString *)keyPathForCellsArray
 keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText
    keyPathForCellLabelText:(NSString *)keyPathForCellLabelText
               sectionMode:(PFTableViewDataSourceMode)sectionMode{
    if (self = [self init]) {
        _anchorObject = anchorObject;
        _keyPathForSectionsArray = keyPathForSectionsArray;
        _keyPathForCellsArray = keyPathForCellsArray;
        _keyPathForSectionLabelText = keyPathForSectionLabelText;
        _keyPathForCellLabelText = keyPathForCellLabelText;
        
    }
    
    return self;
}

+ (PFTableViewDataSource *)TableSectionDataWithAnchorObject:(id)anchorObject keyPathForSectionsArray:(NSString *)keyPathForSectionsArray keyPathForCellsArray:(NSString *)keyPathForCellsArray keyPathForSectionLabelText:(NSString *)keyPathForSectionLabelText keyPathForCellLabelText:(NSString *)keyPathForCellLabelText sectionMode:(PFTableViewDataSourceMode)sectionMode{
    
    PFTableViewDataSource *result = [[PFTableViewDataSource alloc] initWithAnchorObject:anchorObject keyPathForSectionsArray:keyPathForSectionsArray keyPathForCellsArray:keyPathForCellsArray keyPathForSectionLabelText:keyPathForSectionLabelText keyPathForCellLabelText:keyPathForCellLabelText sectionMode:sectionMode];
    return result;
}

@end
