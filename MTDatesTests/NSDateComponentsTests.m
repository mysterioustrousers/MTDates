//
//  NSDateComponentsTests.m
//  MTDates
//
//  Created by Adam Kirk on 9/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NSDateComponentsTests.h"
#import "NSDateComponents+MTDates.h"
#import "NSDate+MTDates.h"

@implementation NSDateComponentsTests

- (void)testCompenentsFromString
{
  NSDateComponents *comps = nil;

  comps = [NSDateComponents mt_componentsFromString:@"10 October 2009"];
  STAssertEqualObjects([NSDate mt_dateFromComponents:comps], [NSDate mt_dateFromYear:2009 month:10 day:10], nil);
  STAssertTrue([comps year] == 2009, nil);
  STAssertTrue([comps month] == 10, nil);
  STAssertTrue([comps day] == 10, nil);

  comps = [NSDateComponents mt_componentsFromString:@"October 2009"];
  STAssertTrue([comps year] == 2009, nil);
  STAssertTrue([comps month] == 10, nil);
  STAssertTrue([comps day] == NSUndefinedDateComponent, nil);

  comps = [NSDateComponents mt_componentsFromString:@"2009"];
  STAssertTrue([comps year] == 2009, nil);
  STAssertTrue([comps month] == NSUndefinedDateComponent, nil);
  STAssertTrue([comps day] == NSUndefinedDateComponent, nil);

  comps = [NSDateComponents mt_componentsFromString:@"10 2009"];
  STAssertTrue([comps year] == 2009, nil);
  STAssertTrue([comps month] == 10, nil);
  STAssertTrue([comps day] == NSUndefinedDateComponent, nil);

  comps = [NSDateComponents mt_componentsFromString:@"10 July"];
  STAssertTrue([comps year] == NSUndefinedDateComponent, nil);
  STAssertTrue([comps month] == 7, nil);
  STAssertTrue([comps day] == 10, nil);

}

- (void)testComponentsStringValue
{
  NSDateComponents *comps = nil;

  comps = [NSDateComponents mt_componentsFromString:@"10 October 2009"];
  STAssertEqualObjects([comps mt_stringValue], @"10 October 2009", nil);

  comps = [NSDateComponents mt_componentsFromString:@"October 2009"];
  STAssertEqualObjects([comps mt_stringValue], @"October 2009", nil);

  comps = [NSDateComponents mt_componentsFromString:@"2009"];
  STAssertEqualObjects([comps mt_stringValue], @"2009", nil);

  comps = [NSDateComponents mt_componentsFromString:@"10 2009"];
  STAssertEqualObjects([comps mt_stringValue], @"October 2009", nil);

  comps = [NSDateComponents mt_componentsFromString:@"10 July"];
  STAssertEqualObjects([comps mt_stringValue], @"10 July", nil);

  comps = [NSDateComponents mt_componentsFromString:@"10"];
  STAssertEqualObjects([comps mt_stringValue], @"October", nil);
}

@end
