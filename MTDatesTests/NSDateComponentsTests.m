//
//  NSDateComponentsTests.m
//  MTDates
//
//  Created by Adam Kirk on 9/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NSDateComponents+MTDates.h"
#import "NSDate+MTDates.h"
#import <XCTest/XCTest.h>


@interface NSDateComponentsTests : XCTestCase

@end


@implementation NSDateComponentsTests

- (void)testCompenentsFromString
{
  NSDateComponents *comps = nil;

  comps = [NSDateComponents mt_componentsFromString:@"10 October 2009"];
  XCTAssertEqualObjects([NSDate mt_dateFromComponents:comps], [NSDate mt_dateFromYear:2009 month:10 day:10]);
  XCTAssertTrue([comps year] == 2009);
  XCTAssertTrue([comps month] == 10);
  XCTAssertTrue([comps day] == 10);

  comps = [NSDateComponents mt_componentsFromString:@"October 2009"];
  XCTAssertTrue([comps year] == 2009);
  XCTAssertTrue([comps month] == 10);
  XCTAssertTrue([comps day] == NSDateComponentUndefined);

  comps = [NSDateComponents mt_componentsFromString:@"2009"];
  XCTAssertTrue([comps year] == 2009);
  XCTAssertTrue([comps month] == NSDateComponentUndefined);
  XCTAssertTrue([comps day] == NSDateComponentUndefined);

  comps = [NSDateComponents mt_componentsFromString:@"10 2009"];
  XCTAssertTrue([comps year] == 2009);
  XCTAssertTrue([comps month] == 10);
  XCTAssertTrue([comps day] == NSDateComponentUndefined);

  comps = [NSDateComponents mt_componentsFromString:@"10 July"];
  XCTAssertTrue([comps year] == NSDateComponentUndefined);
  XCTAssertTrue([comps month] == 7);
  XCTAssertTrue([comps day] == 10);

}

- (void)testComponentsStringValue
{
  NSDateComponents *comps = nil;

  comps = [NSDateComponents mt_componentsFromString:@"10 October 2009"];
  XCTAssertEqualObjects([comps mt_stringValue], @"10 October 2009");

  comps = [NSDateComponents mt_componentsFromString:@"October 2009"];
  XCTAssertEqualObjects([comps mt_stringValue], @"October 2009");

  comps = [NSDateComponents mt_componentsFromString:@"2009"];
  XCTAssertEqualObjects([comps mt_stringValue], @"2009");

  comps = [NSDateComponents mt_componentsFromString:@"10 2009"];
  XCTAssertEqualObjects([comps mt_stringValue], @"October 2009");

  comps = [NSDateComponents mt_componentsFromString:@"10 July"];
  XCTAssertEqualObjects([comps mt_stringValue], @"10 July");

  comps = [NSDateComponents mt_componentsFromString:@"10"];
  XCTAssertEqualObjects([comps mt_stringValue], @"October");
}

@end
