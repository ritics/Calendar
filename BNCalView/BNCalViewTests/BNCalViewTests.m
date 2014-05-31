//
//  BNCalViewTests.m
//  BNCalViewTests
//
//  Created by Reinis Lācis on 17/04/14.
//  Copyright (c) 2014 Brand Name. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BNMWordCountItem.h"
#import "BNMhelperWords.h"

@interface BNCalViewTests : XCTestCase

@end

@implementation BNCalViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    XCTAssertTrue(nil == nil);
}



/**
 *  Pavisam vienkāršs tests
 */
- (void)testWordCountItem
{
    BNMWordCountItem *item = [[BNMWordCountItem alloc]init:@"vārds" count:1];
    XCTAssertNotNil(item, @"Object not created");
}


/**
 *  Vārdu un to biežumu kārtošanas tests
 */
- (void)testSortedWordCount
{
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    NSDate *oneMonthFromNow = [calendar dateByAddingComponents:components
                                                        toDate:now
                                                       options:0];
    NSLog(@"%@", oneMonthFromNow);
    NSDate *twoMonthFromNow = [calendar dateByAddingComponents:components
                                                        toDate:oneMonthFromNow
                                                       options:0];
    NSLog(@"%@", twoMonthFromNow);
    
    
    NSMutableDictionary *noteDic = [[NSMutableDictionary alloc]init];
    
    BNMDateNoteItem *item1 = [[BNMDateNoteItem alloc] initWithNote:@"   un un un un UN un  , , . . , !? []" date:now];
    BNMDateNoteItem *item2 = [[BNMDateNoteItem alloc] initWithNote:@"aa aa aa aa divi DiVi" date:oneMonthFromNow];
    BNMDateNoteItem *item3 = [[BNMDateNoteItem alloc] initWithNote:@"a1 a1 a1 a1" date:twoMonthFromNow];
    
    [noteDic setObject:item1 forKey:item1.identifier];
    [noteDic setObject:item2 forKey:item2.identifier];
    [noteDic setObject:item3 forKey:item3.identifier];
    
    
    /* 
    Parsē katras piezīmes tekstu un rezultātu atgriež
    sakārtotā masīvā
    */
    NSArray *sorted = [BNMhelperWords countWords:noteDic];
    
    XCTAssertNotNil(sorted, @"Object sorted not created");

    
    for(BNMWordCountItem *item in sorted)
    {
        NSLog(@"%@ - %ld", item.word, (long)item.count);
    }
    
    XCTAssertTrue([[[sorted objectAtIndex:0] word] isEqual:@"un"]);
    XCTAssertTrue([[sorted objectAtIndex:0] count] == 6);
    
    XCTAssertTrue([[[sorted objectAtIndex:1] word] isEqual:@"a1"]);
    XCTAssertTrue([[sorted objectAtIndex:1] count] == 4);
    
    XCTAssertTrue([[[sorted objectAtIndex:2] word] isEqual:@"aa"]);
    XCTAssertTrue([[sorted objectAtIndex:2] count] == 4);
    
    XCTAssertTrue([[[sorted objectAtIndex:3] word] isEqual:@"divi"]);
    XCTAssertTrue([[sorted objectAtIndex:3] count] == 2);

}

@end
