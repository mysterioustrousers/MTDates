//
//  MTDatesTests.m
//  MTDatesTests
//
//  Created by Adam Kirk on 8/9/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NSDate+MTDates.h"
#import <XCTest/XCTest.h>


@interface MTDatesTests : XCTestCase
@property (nonatomic, copy) NSCalendar      *calendar;
@property (nonatomic, copy) NSDateFormatter *formatter;
@property (nonatomic, copy) NSDateFormatter *GMTFormatter;
@end


@implementation MTDatesTests

- (void)setUp
{
    NSLocale *locale        = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSTimeZone *timeZone    = [NSTimeZone timeZoneWithName:@"America/Denver"];
    _calendar               = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [NSDate mt_setLocale:locale];
    [NSDate mt_setCalendarIdentifier:_calendar.calendarIdentifier];
    [NSDate mt_setFirstDayOfWeek:_calendar.firstWeekday];
    [NSDate mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)_calendar.minimumDaysInFirstWeek];
    
    _formatter              = [[NSDateFormatter alloc] init];
    _formatter.dateFormat   = @"MM/dd/yyyy hh:mma";
    _formatter.locale       = locale;
    
    _GMTFormatter               = [[NSDateFormatter alloc] init];
    _GMTFormatter.dateFormat    = @"MM/dd/yyyy hh:mma";
    _GMTFormatter.timeZone      = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _GMTFormatter.locale        = locale;
    
    [NSTimeZone setDefaultTimeZone:timeZone];
    
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}




- (NSInteger)dateFormatterDefaultYear
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.calendar = _calendar;
    
    dateFormatter.dateFormat = @"hh:mm";
    NSDate *defaultDate = [dateFormatter dateFromString:@"00:00"];
    
    dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm";
    NSDate *ios6DefaultDate = [dateFormatter dateFromString:@"01/01/2000 00:00"];
    
    if ([defaultDate timeIntervalSinceDate:ios6DefaultDate] == 0) {
        return 2000;
    } else {
        return 1970;
    }
}


- (void)test_SharedFormatter
{
    XCTAssertNotNil([NSDate mt_sharedFormatter]);
}


#pragma mark - CONSTRUCTORS

- (void)test_dateFromISOString
{
    NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    NSDate *date2 = [NSDate mt_dateFromISOString:@"1986-07-11 17:29:00"];
    XCTAssertEqualObjects(date, date2);

    NSDate *date3 = [NSDate mt_dateFromISOString:@"1986-07-11T17:29:00Z"];
    XCTAssertEqualObjects(date, date3);

    NSDate *date4 = [NSDate mt_dateFromISOString:@"1986-07-11 17:29:00 +0000"];
    XCTAssertEqualObjects(date, date4);
}

- (void)test_dateFromString_usingFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [NSDate mt_dateFromString:@"11 July 1986 11-29-am" usingFormat:@"dd MMMM yyyy hh'-'mm'-'a"];
    XCTAssertEqualObjects(date, date2);
}

- (void)test_dateFromYear_month_day
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11], date);
}

- (void)test_dateFromYear_month_day_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29], date);
}

- (void)test_dateFromYear_month_day_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29 second:0], date);
}

- (void)test_dateFromYear_week_weekday
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6], date);
}

- (void)test_dateFromYear_week_weekday_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29], date);
}

- (void)test_dateFromYear_week_weekday_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29 second:0], date);
}

- (void)test_dateByAddingYears_months_weeks_days_hours_minutes_seconds
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/05/1982 10:05am"];
    XCTAssertEqualObjects([date2 mt_dateByAddingYears:4 months:5 weeks:0 days:6 hours:1 minutes:24 seconds:0], date);

    NSDate *date3 = [_formatter dateFromString:@"06/27/1986 10:05am"];
    XCTAssertEqualObjects([date3 mt_dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0], date);
}

- (void)test_startOfToday
{
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [date mt_components];
    XCTAssertEqualObjects([NSDate mt_startOfToday], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]);
}

- (void)test_startOfYesterday
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-86400];
    NSDateComponents *comps = [date mt_components];
    XCTAssertEqualObjects([NSDate mt_startOfYesterday], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]);
}

- (void)test_startOfTomorrow
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:86400];
    NSDateComponents *comps = [date mt_components];
    XCTAssertEqualObjects([NSDate mt_startOfTomorrow], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]);
}

- (void)test_endOfToday
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:-1];
    XCTAssertEqualObjects([NSDate mt_endOfToday], date);
}

- (void)test_endOfTomorrow
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:86400-1];
    XCTAssertEqualObjects([NSDate mt_endOfTomorrow], date);
}

- (void)test_endOfYesterday
{
    NSDate *date = [[NSDate mt_startOfToday] dateByAddingTimeInterval:-1];
    XCTAssertEqualObjects([NSDate mt_endOfYesterday], date);
}


#pragma mark - SYMBOLS

- (void)test_shortWeekdaySymbols
{
    XCTAssertEqual([NSDate mt_shortWeekdaySymbols].count, 7);
}

- (void)test_weekdaySymbols
{
    XCTAssertEqual([NSDate mt_weekdaySymbols].count, 7);
}

- (void)test_veryShortWeekdaySymbols
{
    XCTAssertEqual([NSDate mt_veryShortWeekdaySymbols].count, 7);
}

- (void)test_shortMonthlySymbols
{
    XCTAssertEqual([NSDate mt_shortMonthlySymbols].count, 12);
}

- (void)test_monthlySymbols
{
    XCTAssertEqual([NSDate mt_monthlySymbols].count, 12);
}

- (void)test_veryShortMonthlySymbols
{
    XCTAssertEqual([NSDate mt_veryShortMonthlySymbols].count, 12);
}





#pragma mark - COMPONENTS

- (void)test_year
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_year], 1986);
}

- (void)test_weekOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_weekOfYear], 28);
}

- (void)test_dayOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_dayOfYear], 192);
    // test for leap year as well
    date = [_formatter dateFromString:@"07/11/1988 11:29am"];
    XCTAssertEqual([date mt_dayOfYear], 193);
}

- (void)test_weekOfMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_weekOfMonth], 2);
}

- (void)test_weekdayOfWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_weekdayOfWeek], 6);
}

- (void)test_monthOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_monthOfYear], 7);
}

- (void)test_dayOfMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_dayOfMonth], 11);
}

- (void)test_hourOfDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_hourOfDay], 11);
}

- (void)test_minuteOfHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqual([date mt_minuteOfHour], 29);
}

- (void)test_secondOfMinute
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
    XCTAssertEqual([date mt_secondOfMinute], 33);
}

- (void)test_secondsIntoDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
    XCTAssertEqual([date mt_secondsIntoDay], 41373);
}





#pragma mark - RELATIVES


#pragma mark years

- (void)test_startOfPreviousYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1985 12:00am"];
    XCTAssertEqualObjects([date mt_startOfPreviousYear], date2);
}

- (void)test_startOfCurrentYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfCurrentYear], date2);
}

- (void)test_startOfNextYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1987 12:00am"];
    XCTAssertEqualObjects([date mt_startOfNextYear], date2);
}


- (void)test_middleOfPreviousYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/02/1985 12:59pm"];
    XCTAssertEqualObjects([[date mt_middleOfPreviousYear] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfCurrentYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/02/1986 12:59pm"];
    XCTAssertEqualObjects([[date mt_middleOfCurrentYear] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfNextYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/02/1987 12:59pm"];
    XCTAssertEqualObjects([[date mt_middleOfNextYear] mt_startOfCurrentMinute], date2);
}


- (void)test_endOfPreviousYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1985 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfPreviousYear], date2);
}

- (void)test_endOfCurrentYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfCurrentYear], date2);
}

- (void)test_endOfNextYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfCurrentYear], date2);
}


- (void)test_oneYearPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1985 11:29am"];
    XCTAssertEqualObjects([date mt_oneYearPrevious], date2);
}

- (void)test_oneYearNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1987 11:29am"];
    XCTAssertEqualObjects([date mt_oneYearNext], date2);
}


- (void)test_dateYearsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1982 11:29am"];
    XCTAssertEqualObjects([date mt_dateYearsBefore:4], date2);
}

- (void)test_dateYearsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    XCTAssertEqualObjects([date mt_dateYearsAfter:8], date2);
}


- (void)test_yearsSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    XCTAssertEqual([date2 mt_yearsSinceDate:date], 8);
}


- (void)test_yearsUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    XCTAssertEqual([date mt_yearsUntilDate:date2], 8);
}


#pragma mark months

- (void)test_startOfPreviousMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/01/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfPreviousMonth], date2);
}

- (void)test_startOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/01/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfCurrentMonth], date2);
}

- (void)test_startOfNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/01/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfNextMonth], date2);
}


- (void)test_middleOfPreviousMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/15/1986 11:59pm"];
    XCTAssertEqualObjects([[date mt_middleOfPreviousMonth] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/16/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfCurrentMonth] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/16/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfNextMonth] mt_startOfCurrentMinute], date2);
}


- (void)test_endOfPreviousMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"06/30/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfPreviousMonth], date2);
}

- (void)test_endOfCurrentMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/31/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfCurrentMonth], date2);
}

- (void)test_endOfNextMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"08/31/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfNextMonth], date2);
}


- (void)test_oneMonthPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneMonthPrevious], date2);
}

- (void)test_oneMonthNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneMonthNext], date2);
}


- (void)test_dateMonthsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"03/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateMonthsBefore:4], date2);
}

- (void)test_dateMonthsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateMonthsAfter:3], date2);
}


- (void)test_monthsSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    XCTAssertEqual([date2 mt_monthsSinceDate:date], 3);
}


- (void)test_monthsUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    XCTAssertEqual([date mt_monthsUntilDate:date2], 3);
}



#pragma mark weeks

- (void)test_startOfPreviousWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/29/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfPreviousWeek], date2);
}

- (void)test_startOfCurrentWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/06/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfCurrentWeek], date2);
}

- (void)test_startOfNextWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/13/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfNextWeek], date2);
}


- (void)test_middleOfPreviousWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"7/2/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfPreviousWeek] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfCurrentWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"7/09/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfCurrentWeek] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfNextWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"7/16/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfNextWeek] mt_startOfCurrentMinute], date2);
}


- (void)test_endOfPreviousWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfPreviousWeek], date2);
}

- (void)test_endOfCurrentWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfCurrentWeek], date2);
}

- (void)test_endOfNextWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/19/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfNextWeek], date2);
}


- (void)test_oneWeekPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/04/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneWeekPrevious], date2);
}

- (void)test_oneWeekNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/18/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneWeekNext], date2);
}


- (void)test_dateWeeksBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateWeeksBefore:22], date2);
}

- (void)test_dateWeeksAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"11/21/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateWeeksAfter:19], date2);
}


- (void)test_weeksSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    XCTAssertEqual([date mt_weeksSinceDate:date2], 22);
}


- (void)test_weeksUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    XCTAssertEqual([date2 mt_weeksUntilDate:date], 22);
}


#pragma mark days

- (void)test_startOfPreviousDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfPreviousDay], date2);
}

- (void)test_startOfCurrentDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfCurrentDay], date2);
}

- (void)test_startOfNextDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:00am"];
    XCTAssertEqualObjects([date mt_startOfNextDay], date2);
}


- (void)test_middleOfPreviousDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfPreviousDay] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfCurrentDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfCurrentDay] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfNextDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59am"];
    XCTAssertEqualObjects([[date mt_middleOfNextDay] mt_startOfCurrentMinute], date2);
}


- (void)test_endOfPreviousDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfPreviousDay], date2);
}

- (void)test_endOfCurrentDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfCurrentDay], date2);
}

- (void)test_endOfNextDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfNextDay], date2);
}


- (void)test_oneDayPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneDayPrevious], date2);
}

- (void)test_oneDayNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:29am"];
    XCTAssertEqualObjects([date mt_oneDayNext], date2);
}


- (void)test_dateDaysBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateDaysBefore:6], date2);
}

- (void)test_dateDaysAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    XCTAssertEqualObjects([date mt_dateDaysAfter:4], date2);
}


- (void)test_daysSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    XCTAssertEqual([date2 mt_daysSinceDate:date], 4);
}


- (void)test_daysUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    XCTAssertEqual([date mt_daysUntilDate:date2], 4);
}



#pragma mark hours

- (void)test_startOfPreviousHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:00am"];
    XCTAssertEqualObjects([date mt_startOfPreviousHour], date2);
}

- (void)test_startOfCurrentHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:00am"];
    XCTAssertEqualObjects([date mt_startOfCurrentHour], date2);
}

- (void)test_startOfNextHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00pm"];
    XCTAssertEqualObjects([date mt_startOfNextHour], date2);
}


- (void)test_middleOfPreviousHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:29am"];
    XCTAssertEqualObjects([[date mt_middleOfPreviousHour] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfCurrentHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([[date mt_middleOfCurrentHour] mt_startOfCurrentMinute], date2);
}

- (void)test_middleOfNextHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:29pm"];
    XCTAssertEqualObjects([[date mt_middleOfNextHour] mt_startOfCurrentMinute], date2);
}


- (void)test_endOfPreviousHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:59:59am"];
    XCTAssertEqualObjects([date mt_endOfPreviousHour], date2);
}

- (void)test_endOfCurrentHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59am"];
    XCTAssertEqualObjects([date mt_endOfCurrentHour], date2);
}

//- (void)test_endOfCurrentHourDST
//{
//    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
//    _formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    NSDate *date = [_formatter dateFromString:@"11/01/2015 02:30:00am"];
//    NSDate *date2 = [_formatter dateFromString:@"11/01/2015 02:59:59am"];
//    XCTAssertEqualObjects([date mt_endOfCurrentHour], date2);
//}

- (void)test_endOfNextHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:59:59pm"];
    XCTAssertEqualObjects([date mt_endOfNextHour], date2);
}


- (void)test_oneHourPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:29am"];
    XCTAssertEqualObjects([date mt_oneHourPrevious], date2);
}

- (void)test_oneHourNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:29pm"];
    XCTAssertEqualObjects([date mt_oneHourNext], date2);
}


- (void)test_dateHoursBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29am"];
    XCTAssertEqualObjects([date mt_dateHoursBefore:6], date2);
}

- (void)test_dateHoursAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29pm"];
    XCTAssertEqualObjects([date mt_dateHoursAfter:6], date2);
}


- (void)test_hoursSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertEqual([date mt_hoursSinceDate:date2], 4);
}


- (void)test_hoursUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertEqual([date2 mt_hoursUntilDate:date], 4);
}

#pragma mark - SECONDS

- (void)test_oneSecondNext {
    NSDate *date = [NSDate date];
    XCTAssertEqual([date.mt_oneSecondNext timeIntervalSinceDate:date], 1);
}

#pragma mark - COMPARES

- (void)test_isAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertTrue([date mt_isAfter:date2]);
}

- (void)test_isBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertTrue([date2 mt_isBefore:date]);
}

- (void)test_isOnOrAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertTrue([date2 mt_isOnOrAfter:date]);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:30am"];
    XCTAssertTrue([date3 mt_isOnOrAfter:date]);
}

- (void)test_isOnOrBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertTrue([date2 mt_isOnOrBefore:date]);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:28am"];
    XCTAssertTrue([date3 mt_isOnOrBefore:date]);
}

- (void)test_isWithinSameYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"03/28/1986 07:29am"];
    XCTAssertTrue([date2 mt_isWithinSameYear:date]);
    NSDate *date3 = [_formatter dateFromString:@"01/01/1987 00:00am"];
    XCTAssertFalse([date3 mt_isWithinSameYear:date]);
    NSDate *date4 = [_formatter dateFromString:@"12/31/1985 11:59pm"];
    XCTAssertFalse([date4 mt_isWithinSameYear:date]);
}

- (void)test_isWithinSameMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/28/1986 07:29am"];
    XCTAssertTrue([date2 mt_isWithinSameMonth:date]);
    NSDate *date3 = [_formatter dateFromString:@"08/01/1986 07:29am"];
    XCTAssertFalse([date3 mt_isWithinSameMonth:date]);
    NSDate *date4 = [_formatter dateFromString:@"06/01/1986 07:29am"];
    XCTAssertFalse([date4 mt_isWithinSameMonth:date]);
}

- (void)test_isWithinSameWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 07:29am"];
    XCTAssertTrue([date2 mt_isWithinSameWeek:date]);
    NSDate *date3 = [_formatter dateFromString:@"07/13/1986 07:29am"];
    XCTAssertFalse([date3 mt_isWithinSameWeek:date]);
    NSDate *date4 = [_formatter dateFromString:@"06/05/1986 07:29am"];
    XCTAssertFalse([date4 mt_isWithinSameWeek:date]);
}

- (void)test_isWithinSameDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertTrue([date2 mt_isWithinSameDay:date]);
    NSDate *date3 = [_formatter dateFromString:@"07/12/1986 12:00am"];
    XCTAssertFalse([date3 mt_isWithinSameDay:date]);
    NSDate *date4 = [_formatter dateFromString:@"07/10/1986 07:29am"];
    XCTAssertFalse([date4 mt_isWithinSameDay:date]);
}

- (void)test_isWithinSameHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:07am"];
    XCTAssertTrue([date2 mt_isWithinSameHour:date]);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    XCTAssertFalse([date3 mt_isWithinSameHour:date]);
    NSDate *date4 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    XCTAssertFalse([date4 mt_isWithinSameHour:date]);
}





#pragma mark - STRINGS

- (void)test_settingDateFormattingDateStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    [NSDate mt_setFormatterDateStyle:NSDateFormatterLongStyle];
    XCTAssertEqualObjects([date mt_stringValue], @"July 11, 1986 at 11:00 PM");

    [NSDate mt_setFormatterTimeStyle:NSDateFormatterNoStyle];
    XCTAssertEqualObjects([date mt_stringValue], @"July 11, 1986");
}

- (void)test_settingDateFormattingTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    [NSDate mt_setFormatterTimeStyle:NSDateFormatterMediumStyle];
    XCTAssertEqualObjects([date mt_stringValue], @"July 11, 1986 at 11:00:00 PM");

    [NSDate mt_setFormatterDateStyle:NSDateFormatterNoStyle];
    XCTAssertEqualObjects([date mt_stringValue], @"11:00:00 PM");
}

- (void)test_stringValueWithDateStyleTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    NSString *s = [date mt_stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
    XCTAssertEqualObjects(s, @"Friday, July 11, 1986 at 11:00 PM");
}

- (void)test_stringFromDateWithHourAndMinuteFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    XCTAssertEqualObjects([date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour], @"23:00");
    XCTAssertEqualObjects([date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat12Hour], @"11:00 PM");
}

- (void)test_stringFromDatesShortMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithShortMonth], @"Jul");
}

- (void)test_stringFromDatesFullMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithFullMonth], @"July");
}

- (void)test_stringWithAMPMSymbol
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithAMPMSymbol], @"AM");
}

- (void)test_stringWithShortWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithShortWeekdayTitle], @"Fri");
}

- (void)test_stringWithFullWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithFullWeekdayTitle], @"Friday");
}

- (void)test_stringFromDateWithFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:@"MMM dd yyyy" localized:YES], @"Jul 11, 1986");
}

- (void)test_stringFromDateWithISODateTime
{
    NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    XCTAssertEqualObjects([date mt_stringFromDateWithISODateTime], @"1986-07-11 17:29:00 +0000");
}

- (void)test_stringFromDateWithGreatestComponentsForInterval
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    XCTAssertEqualObjects([date mt_stringFromDateWithGreatestComponentsForSecondsPassed:3002], @"50 minutes, 2 seconds after");
}

- (void)test_stringFromDateWithGreatestComponentsUntilDate
{
    NSDate *date1 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:33pm"];
    XCTAssertEqualObjects([date1 mt_stringFromDateWithGreatestComponentsUntilDate:date2], @"In 1 day, 1 hour, 4 minutes");
}





#pragma mark - MISC

- (void)test_datesCollectionFromDate_untilDate
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    NSArray *dates = [NSDate mt_datesCollectionFromDate:date untilDate:date2];
    XCTAssertEqual(dates.count, 9);
}

- (void)test_hoursInCurrentDayAsDatesCollection
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
    XCTAssertEqual([date mt_hoursInCurrentDayAsDatesCollection].count, 24);
}

- (void)test_isInAM
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
    XCTAssertTrue([date mt_isInAM]);
}

- (void)test_isStartOfAnHour
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
    XCTAssertTrue([date mt_isStartOfAnHour]);
}

- (void)test_weekdayStartOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    XCTAssertEqual([date mt_weekdayStartOfCurrentMonth], 3);
}

- (void)test_daysInCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    XCTAssertEqual([date mt_daysInCurrentMonth], 31);
}

- (void)test_daysInPreviousMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    XCTAssertEqual([date mt_daysInPreviousMonth], 30);
}

- (void)test_daysInNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    XCTAssertEqual([date mt_daysInNextMonth], 31);
}

- (void)test_toTimeZone
{
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];
    NSDate *salt_lake = [_formatter dateFromString:@"07/11/1986 09:23am"];
    
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    NSDate *los_angeles = [_formatter dateFromString:@"07/11/1986 08:23am"];
    
    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
    XCTAssertEqualObjects([salt_lake mt_inTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]], los_angeles);
}





#pragma mark - INTERNATIONAL WEEK TESTS

- (void)test_firstDayOfWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Sun");

    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Mon");

    [NSDate mt_setFirstDayOfWeek:3];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Tue");

    [NSDate mt_setFirstDayOfWeek:4];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Wed");

    [NSDate mt_setFirstDayOfWeek:5];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Thu");

    [NSDate mt_setFirstDayOfWeek:6];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Fri");

    [NSDate mt_setFirstDayOfWeek:7];
    XCTAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Sat");

    [NSDate mt_setFirstDayOfWeek:1];
}

- (void)test_firstWeekOfYear
{
    NSDate *date = nil;
    
    // Jan 1st is a sunday
    date = [_formatter dateFromString:@"01/01/2012 12:00am"];
    
    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 52);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a monday
    date = [_formatter dateFromString:@"01/01/2001 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 1);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a tuesday
    date = [_formatter dateFromString:@"01/01/2002 12:00am"];
    
    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 1);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a wednesday
    date = [_formatter dateFromString:@"01/01/2003 12:00am"];
    
    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 1);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a thursday
    date = [_formatter dateFromString:@"01/01/2004 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 1);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a friday
    date = [_formatter dateFromString:@"01/01/2010 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 53);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // Jan 1st is a saturday
    date = [_formatter dateFromString:@"01/01/2011 12:00am"];
    
    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    XCTAssertEqual([date mt_weekOfYear], 52);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    XCTAssertEqual([date mt_weekOfYear], 1);

    // reset for other tests
    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
}



#pragma mark - TIMEZONE TESTS

- (void)test_changeTimezone
{
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];
    NSDate *saltLake = [NSDate mt_dateFromYear:2012 month:9 day:18 hour:19 minute:29];
    
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    NSDate *seattle = [NSDate mt_dateFromYear:2012 month:9 day:18 hour:18 minute:29];

    XCTAssertEqualObjects(saltLake, seattle);

    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *septStartDenver = [_formatter dateFromString:@"09/01/2012 01:00:00am"];
    NSDate *septEndDenver = [_formatter dateFromString:@"10/01/2012 12:59:59am"];
    
    NSDate *losAngeles = [NSDate mt_dateFromYear:2012 month:9 day:20 hour:9 minute:49 second:11];

    XCTAssertEqualObjects([losAngeles mt_startOfCurrentMonth], septStartDenver);

    XCTAssertEqualObjects([losAngeles mt_endOfCurrentMonth], septEndDenver);

    XCTAssertEqual([losAngeles mt_daysInCurrentMonth], 30);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}





#pragma mark - COMMON DATE FORMATS

- (void)test_MTDatesFormatDefault
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
    NSString *string = @"Sat, Jun 09, 2007, 17:46:21";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatDefault], date);
    NSString *formatted = [date mt_stringFromDateWithFormat:MTDatesFormatDefault localized:YES];
    XCTAssertEqualObjects(formatted, string);
}

- (void)test_MTDatesFormatShortDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"6/9/07";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortDate], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatShortDate localized:YES], string);
}

- (void)test_MTDatesFormatMediumDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Jun 9, 2007";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumDate], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatMediumDate localized:YES], string);
}

- (void)test_MTDatesFormatLongDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"June 9, 2007";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongDate], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatLongDate localized:YES], string);
}

- (void)test_MTDatesFormatFullDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Saturday, June 9, 2007";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatFullDate], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatFullDate localized:YES], string);
}

- (void)test_MTDatesFormatShortTime
{
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46 PM";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortTime], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatShortTime localized:YES], string);
}

- (void)test_MTDatesFormatMediumTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumTime], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatMediumTime localized:YES], string);
}

- (void)test_MTDatesFormatLongTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa zzz";
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm EST", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM EST";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongTime], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatLongTime localized:YES], string);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}

- (void)test_MTDatesFormatISODate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"2007-06-09";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODate], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISODate localized:NO], string);
}

- (void)test_MTDatesFormatISOTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"17:46:21";

    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISOTime], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISOTime localized:YES], string);
}

- (void)test_MTDatesFormatISODateTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
    
    NSString *string = @"2007-06-09 17:46:21";
    XCTAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODateTime], date);
    XCTAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISODateTime localized:NO], string);
}

- (void)test_MTDatesBlockInvoke {
    dispatch_queue_t queue = dispatch_queue_create("mtdates-test", NULL);
    dispatch_async(queue, ^{
        NSDate * date = [NSDate mt_dateFromYear:2013 month:1 day:1];
        XCTAssertNotNil(date);
    });
    dispatch_release(queue);
}

- (void)test_japaneseCalendar
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
    
    [NSDate mt_setCalendarIdentifier:NSJapaneseCalendar];

    XCTAssertEqual([date mt_year],         19);
    XCTAssertEqual([date mt_monthOfYear],  6);
    XCTAssertEqual([date mt_dayOfMonth],   9);

    NSDate *date1 = [date mt_startOfCurrentMonth];
    XCTAssertEqual([date1 mt_year],        19);
    XCTAssertEqual([date1 mt_monthOfYear], 6);
    XCTAssertEqual([date1 mt_dayOfMonth],  1);

    NSDate *date2 = [date mt_startOfCurrentYear];
    XCTAssertEqual([date2 mt_year],        19);
    XCTAssertEqual([date2 mt_monthOfYear], 1);
    XCTAssertEqual([date2 mt_dayOfMonth],  1);

    [NSDate mt_setCalendarIdentifier:NSCalendarIdentifierGregorian];
}

@end
