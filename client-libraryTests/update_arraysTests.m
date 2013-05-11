//
//  update_arraysTests.m
//  update arraysTests
//
//  Created by Jeff Wolski on 5/10/13.
//  Copyright (c) 2013 Organization Name. All rights reserved.
//

#import "update_arraysTests.h"
#import "NSMutableArray+PFUpdate.h"



@implementation update_arraysTests
NSMutableArray *originalArray;
NSArray *newArray;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    originalArray = [NSMutableArray alloc];
    newArray = [NSArray alloc];
}

- (void)tearDown
{
    
    originalArray = nil;
    newArray = nil;
    // Tear-down code here.
    
    [super tearDown];
    
}

- (void)testInserts1{
    originalArray = [originalArray initWithObjects:@"a", nil];
    newArray = [newArray initWithObjects:@"a",@"b",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testInserts2{
    originalArray = [originalArray initWithObjects:@"b", nil];
    newArray = [newArray initWithObjects:@"a",@"b",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testInserts3{
    originalArray = [originalArray initWithObjects:@"a",@"b", nil];
    newArray = [newArray initWithObjects:@"a",@"b",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testInserts4{
    originalArray = [originalArray initWithObjects:@"a",@"c", nil];
    newArray = [newArray initWithObjects:@"a",@"b",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testRemove1{
    originalArray = [originalArray initWithObjects:@"a",@"c", nil];
    newArray = [newArray initWithObjects:@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testRemove2{
    originalArray = [originalArray initWithObjects:@"a", nil];
    newArray = [newArray initWithObjects:@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testRemove3{
    originalArray = [originalArray initWithObjects:@"a",@"b", nil];
    newArray = [newArray initWithObjects:@"a",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testRemove4{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"x", nil];
    newArray = [newArray initWithObjects:@"a",@"x",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort1{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c", nil];
    newArray = [newArray initWithObjects:@"a",@"c",@"b", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}

- (void)testSort2{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c", nil];
    newArray = [newArray initWithObjects:@"b",@"a", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort3{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c", nil];
    newArray = [newArray initWithObjects:@"b",@"x",@"a", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort4{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c",@"d", nil];
    newArray = [newArray initWithObjects:@"b",@"x",@"a", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort5{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c",@"d", nil];
    newArray = [newArray initWithObjects:@"b",@"x",@"a",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort6{
    originalArray = [originalArray initWithObjects:@"O",@"a",@"z",@"b",@"c",@"d", nil];
    newArray = [newArray initWithObjects:@"b",@"x",@"a",@"c", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort7{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f", nil];
    newArray = [newArray initWithObjects:@"d",@"c",@"f", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testSort8{
    originalArray = [originalArray initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f", nil];
    newArray = [newArray initWithObjects:@"b",@"d",@"y",@"c",@"f",@"z", nil];
    [originalArray updateToMatchArray:newArray];
    STAssertEqualObjects(originalArray, newArray, @"arrays should be equal");
    
}
- (void)testExample
{
    STAssertNotNil(originalArray, @"OriginalArray is nil");

    originalArray = [originalArray init];
    STAssertTrue(originalArray.count>=0, @"originalArray count should be >= 0");
    [originalArray addObject:@"a"];
    STAssertTrue(originalArray.count>0, @"originalArray count should be > 0");
}

@end
