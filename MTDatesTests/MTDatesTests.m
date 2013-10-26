//
//  MTDatesTests.m
//  MTDatesTests
//
//  Created by Adam Kirk on 8/9/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NSDate+MTDates.h"
#import <SenTestingKit/SenTestingKit.h>


@interface MTDatesTests : SenTestCase
@property (nonatomic, copy) NSCalendar      *calendar;
@property (nonatomic, copy) NSDateFormatter *formatter;
@property (nonatomic, copy) NSDateFormatter *GMTFormatter;
@end


@implementation MTDatesTests

- (void)setUp
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/Denver"];
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    [NSDate mt_setLocale:locale];
    [NSDate mt_setCalendarIdentifier:_calendar.calendarIdentifier];
    [NSDate mt_setFirstDayOfWeek:_calendar.firstWeekday];
    [NSDate mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)_calendar.minimumDaysInFirstWeek];

    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"MM/dd/yyyy hh:mma";
    _formatter.locale = locale;

    _GMTFormatter = [[NSDateFormatter alloc] init];
    _GMTFormatter.dateFormat = @"MM/dd/yyyy hh:mma";
    _GMTFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _GMTFormatter.locale = locale;

    [NSTimeZone setDefaultTimeZone:timeZone];

    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}




- (NSInteger)dateFormatterDefaultYear {
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
    STAssertNotNil([NSDate mt_sharedFormatter], nil);
}


#pragma mark - CONSTRUCTORS

- (void)test_dateFromISOString
{
    NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    NSDate *date2 = [NSDate mt_dateFromISOString:@"1986-07-11 17:29:00"];
    STAssertEqualObjects(date, date2, nil);

    NSDate *date3 = [NSDate mt_dateFromISOString:@"1986-07-11T17:29:00Z"];
    STAssertEqualObjects(date, date3, nil);

    NSDate *date4 = [NSDate mt_dateFromISOString:@"1986-07-11 17:29:00 +0000"];
    STAssertEqualObjects(date, date4, nil);
}

- (void)test_dateFromString_usingFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [NSDate mt_dateFromString:@"11 July 1986 11-29-am" usingFormat:@"dd MMMM yyyy hh'-'mm'-'a"];
    STAssertEqualObjects(date, date2, nil);
}

- (void)test_dateFromYear_month_day
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11], date, nil);
}

- (void)test_dateFromYear_month_day_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29], date, nil);
}

- (void)test_dateFromYear_month_day_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29 second:0], date, nil);
}

- (void)test_dateFromYear_week_weekday
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6], date, nil);
}

- (void)test_dateFromYear_week_weekday_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29], date, nil);
}

- (void)test_dateFromYear_week_weekday_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29 second:0], date, nil);
}

- (void)test_dateByAddingYears_months_weeks_days_hours_minutes_seconds
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/05/1982 10:05am"];
    STAssertEqualObjects([date2 mt_dateByAddingYears:4 months:5 weeks:0 days:6 hours:1 minutes:24 seconds:0], date, nil);

    NSDate *date3 = [_formatter dateFromString:@"06/27/1986 10:05am"];
    STAssertEqualObjects([date3 mt_dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0], date, nil);
}

- (void)test_startOfToday
{
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [date mt_components];
    STAssertEqualObjects([NSDate mt_startOfToday], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]], nil);
}

- (void)test_startOfYesterday
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-86400];
    NSDateComponents *comps = [date mt_components];
    STAssertEqualObjects([NSDate mt_startOfYesterday], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]], nil);
}

- (void)test_startOfTomorrow
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:86400];
    NSDateComponents *comps = [date mt_components];
    STAssertEqualObjects([NSDate mt_startOfTomorrow], [NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]], nil);
}

- (void)test_endOfToday
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:-1];
    STAssertEqualObjects([NSDate mt_endOfToday], date, nil);
}

- (void)test_endOfTomorrow
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:86400-1];
    STAssertEqualObjects([NSDate mt_endOfTomorrow], date, nil);
}

- (void)test_endOfYesterday
{
    NSDate *date = [[NSDate mt_startOfToday] dateByAddingTimeInterval:-1];
    STAssertEqualObjects([NSDate mt_endOfYesterday], date, nil);
}


#pragma mark - SYMBOLS

- (void)test_shortWeekdaySymbols
{
    STAssertTrue([NSDate mt_shortWeekdaySymbols].count == 7, nil);
}

- (void)test_weekdaySymbols
{
    STAssertTrue([NSDate mt_weekdaySymbols].count == 7, nil);
}

- (void)test_veryShortWeekdaySymbols
{
    STAssertTrue([NSDate mt_veryShortWeekdaySymbols].count == 7, nil);
}

- (void)test_shortMonthlySymbols
{
    STAssertTrue([NSDate mt_shortMonthlySymbols].count == 12, nil);
}

- (void)test_monthlySymbols
{
    STAssertTrue([NSDate mt_monthlySymbols].count == 12, nil);
}

- (void)test_veryShortMonthlySymbols
{
    STAssertTrue([NSDate mt_veryShortMonthlySymbols].count == 12, nil);
}





#pragma mark - COMPONENTS

- (void)test_year
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_year] == 1986, nil);
}

- (void)test_weekOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_weekOfYear] == 28, nil);
}

- (void)test_dayOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_dayOfYear] == 192, nil);
    // test for leap year as well
    date = [_formatter dateFromString:@"07/11/1988 11:29am"];
    STAssertTrue([date mt_dayOfYear] == 193, nil);
}

- (void)test_weekOfMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_weekOfMonth] == 2, nil);
}

- (void)test_weekdayOfWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_weekdayOfWeek] == 6, nil);
}

- (void)test_monthOfYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_monthOfYear] == 7, nil);
}

- (void)test_dayOfMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_dayOfMonth] == 11, nil);
}

- (void)test_hourOfDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_hourOfDay] == 11, nil);
}

- (void)test_minuteOfHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date mt_minuteOfHour] == 29, nil);
}

- (void)test_secondOfMinute
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
    STAssertTrue([date mt_secondOfMinute] == 33, nil);
}

- (void)test_secondsIntoDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
    STAssertTrue([date mt_secondsIntoDay] == 41373, nil);
}





#pragma mark - RELATIVES


#pragma mark years

- (void)test_startOfPreviousYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1985 12:00am"];
    STAssertEqualObjects([date mt_startOfPreviousYear], date2, nil);
}

- (void)test_startOfCurrentYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfCurrentYear], date2, nil);
}

- (void)test_startOfNextYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1987 12:00am"];
    STAssertEqualObjects([date mt_startOfNextYear], date2, nil);
}


- (void)test_endOfPreviousYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1985 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfPreviousYear], date2, nil);
}

- (void)test_endOfCurrentYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfCurrentYear], date2, nil);
}

- (void)test_endOfNextYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfCurrentYear], date2, nil);
}


- (void)test_oneYearPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1985 11:29am"];
    STAssertEqualObjects([date mt_oneYearPrevious], date2, nil);
}

- (void)test_oneYearNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1987 11:29am"];
    STAssertEqualObjects([date mt_oneYearNext], date2, nil);
}


- (void)test_dateYearsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1982 11:29am"];
    STAssertEqualObjects([date mt_dateYearsBefore:4], date2, nil);
}

- (void)test_dateYearsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    STAssertEqualObjects([date mt_dateYearsAfter:8], date2, nil);
}


- (void)test_yearsSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    STAssertTrue([date2 mt_yearsSinceDate:date] == 8, nil);
}


- (void)test_yearsUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    STAssertTrue([date mt_yearsUntilDate:date2] == 8, nil);
}


#pragma mark months

- (void)test_startOfPreviousMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/01/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfPreviousMonth], date2, nil);
}

- (void)test_startOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/01/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfCurrentMonth], date2, nil);
}

- (void)test_startOfNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/01/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfNextMonth], date2, nil);
}


- (void)test_endOfPreviousMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"06/30/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfPreviousMonth], date2, nil);
}

- (void)test_endOfCurrentMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/31/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfCurrentMonth], date2, nil);
}

- (void)test_endOfNextMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"08/31/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfNextMonth], date2, nil);
}


- (void)test_oneMonthPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/11/1986 11:29am"];
    STAssertEqualObjects([date mt_oneMonthPrevious], date2, nil);
}

- (void)test_oneMonthNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/11/1986 11:29am"];
    STAssertEqualObjects([date mt_oneMonthNext], date2, nil);
}


- (void)test_dateMonthsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"03/11/1986 11:29am"];
    STAssertEqualObjects([date mt_dateMonthsBefore:4], date2, nil);
}

- (void)test_dateMonthsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    STAssertEqualObjects([date mt_dateMonthsAfter:3], date2, nil);
}


- (void)test_monthsSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    STAssertTrue([date2 mt_monthsSinceDate:date] == 3, nil);
}


- (void)test_monthsUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    STAssertTrue([date mt_monthsUntilDate:date2] == 3, nil);
}



#pragma mark weeks

- (void)test_startOfPreviousWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/29/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfPreviousWeek], date2, nil);
}

- (void)test_startOfCurrentWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/06/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfCurrentWeek], date2, nil);
}

- (void)test_startOfNextWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/13/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfNextWeek], date2, nil);
}


- (void)test_endOfPreviousWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfPreviousWeek], date2, nil);
}

- (void)test_endOfCurrentWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfCurrentWeek], date2, nil);
}

- (void)test_endOfNextWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/19/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfNextWeek], date2, nil);
}


- (void)test_oneWeekPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/04/1986 11:29am"];
    STAssertEqualObjects([date mt_oneWeekPrevious], date2, nil);
}

- (void)test_oneWeekNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/18/1986 11:29am"];
    STAssertEqualObjects([date mt_oneWeekNext], date2, nil);
}


- (void)test_dateWeeksBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    STAssertEqualObjects([date mt_dateWeeksBefore:22], date2, nil);
}

- (void)test_dateWeeksAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"11/21/1986 11:29am"];
    STAssertEqualObjects([date mt_dateWeeksAfter:19], date2, nil);
}


- (void)test_weeksSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    STAssertTrue([date mt_weeksSinceDate:date2] == 22, nil);
}


- (void)test_weeksUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    STAssertTrue([date2 mt_weeksUntilDate:date] == 22, nil);
}


#pragma mark days

- (void)test_startOfPreviousDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfPreviousDay], date2, nil);
}

- (void)test_startOfCurrentDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfCurrentDay], date2, nil);
}

- (void)test_startOfNextDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:00am"];
    STAssertEqualObjects([date mt_startOfNextDay], date2, nil);
}


- (void)test_endOfPreviousDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfPreviousDay], date2, nil);
}

- (void)test_endOfCurrentDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfCurrentDay], date2, nil);
}

- (void)test_endOfNextDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    STAssertEqualObjects([date mt_endOfNextDay], date2, nil);
}


- (void)test_oneDayPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:29am"];
    STAssertEqualObjects([date mt_oneDayPrevious], date2, nil);
}

- (void)test_oneDayNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:29am"];
    STAssertEqualObjects([date mt_oneDayNext], date2, nil);
}


- (void)test_dateDaysBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:29am"];
    STAssertEqualObjects([date mt_dateDaysBefore:6], date2, nil);
}

- (void)test_dateDaysAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    STAssertEqualObjects([date mt_dateDaysAfter:4], date2, nil);
}


- (void)test_daysSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    STAssertTrue([date2 mt_daysSinceDate:date] == 4, nil);
}


- (void)test_daysUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    STAssertTrue([date mt_daysUntilDate:date2] == 4, nil);
}



#pragma mark hours

- (void)test_startOfPreviousHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:00am"];
    STAssertEqualObjects([date mt_startOfPreviousHour], date2, nil);
}

- (void)test_startOfCurrentHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:00am"];
    STAssertEqualObjects([date mt_startOfCurrentHour], date2, nil);
}

- (void)test_startOfNextHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00pm"];
    STAssertEqualObjects([date mt_startOfNextHour], date2, nil);
}


- (void)test_endOfPreviousHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:59:59am"];
    STAssertEqualObjects([date mt_endOfPreviousHour], date2, nil);
}

- (void)test_endOfCurrentHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59am"];
    STAssertEqualObjects([date mt_endOfCurrentHour], date2, nil);
}

- (void)test_endOfNextHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:59:59pm"];
    STAssertEqualObjects([date mt_endOfNextHour], date2, nil);
}


- (void)test_oneHourPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:29am"];
    STAssertEqualObjects([date mt_oneHourPrevious], date2, nil);
}

- (void)test_oneHourNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:29pm"];
    STAssertEqualObjects([date mt_oneHourNext], date2, nil);
}


- (void)test_dateHoursBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29am"];
    STAssertEqualObjects([date mt_dateHoursBefore:6], date2, nil);
}

- (void)test_dateHoursAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29pm"];
    STAssertEqualObjects([date mt_dateHoursAfter:6], date2, nil);
}


- (void)test_hoursSinceDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertTrue([date mt_hoursSinceDate:date2] == 4, nil);
}


- (void)test_hoursUntilDate
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertTrue([date2 mt_hoursUntilDate:date] == 4, nil);
}



#pragma mark - COMPARES

- (void)test_isAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertTrue([date mt_isAfter:date2], nil);
}

- (void)test_isBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertTrue([date2 mt_isBefore:date], nil);
}

- (void)test_isOnOrAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date2 mt_isOnOrAfter:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:30am"];
    STAssertTrue([date3 mt_isOnOrAfter:date], nil);
}

- (void)test_isOnOrBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([date2 mt_isOnOrBefore:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:28am"];
    STAssertTrue([date3 mt_isOnOrBefore:date], nil);
}

- (void)test_isWithinSameMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/28/1986 07:29am"];
    STAssertTrue([date2 mt_isWithinSameMonth:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"08/01/1986 07:29am"];
    STAssertFalse([date3 mt_isWithinSameMonth:date], nil);
    NSDate *date4 = [_formatter dateFromString:@"06/01/1986 07:29am"];
    STAssertFalse([date4 mt_isWithinSameMonth:date], nil);
}

- (void)test_isWithinSameWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 07:29am"];
    STAssertTrue([date2 mt_isWithinSameWeek:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"07/13/1986 07:29am"];
    STAssertFalse([date3 mt_isWithinSameWeek:date], nil);
    NSDate *date4 = [_formatter dateFromString:@"06/05/1986 07:29am"];
    STAssertFalse([date4 mt_isWithinSameWeek:date], nil);
}

- (void)test_isWithinSameDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertTrue([date2 mt_isWithinSameDay:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"07/12/1986 12:00am"];
    STAssertFalse([date3 mt_isWithinSameDay:date], nil);
    NSDate *date4 = [_formatter dateFromString:@"07/10/1986 07:29am"];
    STAssertFalse([date4 mt_isWithinSameDay:date], nil);
}

- (void)test_isWithinSameHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:07am"];
    STAssertTrue([date2 mt_isWithinSameHour:date], nil);
    NSDate *date3 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertFalse([date3 mt_isWithinSameHour:date], nil);
    NSDate *date4 = [_formatter dateFromString:@"07/11/1986 07:29am"];
    STAssertFalse([date4 mt_isWithinSameHour:date], nil);
}





#pragma mark - STRINGS

- (void)test_settingDateFormattingDateStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    [NSDate mt_setFormatterDateStyle:NSDateFormatterLongStyle];

    NSString *s = [date mt_stringValue];
    STAssertTrue([self levenshteinDistanceWithString:s fromString:@"July 11, 1986 11:00 PM"] < 4, nil);

    [NSDate mt_setFormatterTimeStyle:NSDateFormatterNoStyle];
    STAssertEqualObjects([date mt_stringValue], @"July 11, 1986", nil);
}

- (void)test_settingDateFormattingTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    [NSDate mt_setFormatterTimeStyle:NSDateFormatterMediumStyle];

    NSString *s = [date mt_stringValue];
    STAssertTrue([self levenshteinDistanceWithString:s fromString:@"July 11, 1986 11:00:00 PM"] < 4, nil);

    [NSDate mt_setFormatterDateStyle:NSDateFormatterNoStyle];
    STAssertEqualObjects([date mt_stringValue], @"11:00:00 PM", nil);
}

- (void)test_stringValueWithDateStyleTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    NSString *s = [date mt_stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];
    STAssertTrue([self levenshteinDistanceWithString:s fromString:@"Friday, July 11, 1986 11:00 PM"] < 4, nil);
}

- (void)test_stringFromDateWithHourAndMinuteFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    STAssertEqualObjects([date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour], @"23:00", nil);
    STAssertEqualObjects([date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat12Hour], @"11:00 PM", nil);
}

- (void)test_stringFromDatesShortMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithShortMonth], @"Jul", nil);
}

- (void)test_stringFromDatesFullMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithFullMonth], @"July", nil);
}

- (void)test_stringWithAMPMSymbol
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithAMPMSymbol], @"AM", nil);
}

- (void)test_stringWithShortWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithShortWeekdayTitle], @"Fri", nil);
}

- (void)test_stringWithFullWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithFullWeekdayTitle], @"Friday", nil);
}

- (void)test_stringFromDateWithFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithFormat:@"MMM dd yyyy" localized:YES], @"Jul 11, 1986", nil);
}

- (void)test_stringFromDateWithISODateTime
{
    NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    STAssertEqualObjects([date mt_stringFromDateWithISODateTime], @"1986-07-11 17:29:00 +0000", nil);
}

- (void)test_stringFromDateWithGreatestComponentsForInterval
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertEqualObjects([date mt_stringFromDateWithGreatestComponentsForSecondsPassed:3002], @"50 minutes, 2 seconds after", nil);
}

- (void)test_stringFromDateWithGreatestComponentsUntilDate
{
    NSDate *date1 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:33pm"];
    STAssertEqualObjects([date1 mt_stringFromDateWithGreatestComponentsUntilDate:date2], @"In 1 day, 1 hour, 4 minutes", nil);
}





#pragma mark - MISC

- (void)test_datesCollectionFromDate_untilDate
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    NSArray *dates = [NSDate mt_datesCollectionFromDate:date untilDate:date2];
    STAssertTrue(dates.count == 9, nil);
}

- (void)test_hoursInCurrentDayAsDatesCollection
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
    STAssertTrue([date mt_hoursInCurrentDayAsDatesCollection].count == 24, nil);
}

- (void)test_isInAM
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
    STAssertTrue([date mt_isInAM], nil);
}

- (void)test_isStartOfAnHour
{
    NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
    STAssertTrue([date mt_isStartOfAnHour], nil);
}

- (void)test_weekdayStartOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    STAssertTrue([date mt_weekdayStartOfCurrentMonth] == 3, nil);
}

- (void)test_daysInCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    STAssertTrue([date mt_daysInCurrentMonth] == 31, nil);
}

- (void)test_daysInPreviousMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    STAssertTrue([date mt_daysInPreviousMonth] == 30, nil);
}

- (void)test_daysInNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
    STAssertTrue([date mt_daysInNextMonth] == 31, nil);
}

- (void)test_toTimeZone
{
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];
    NSDate *salt_lake = [_formatter dateFromString:@"07/11/1986 09:23am"];

    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    NSDate *los_angeles = [_formatter dateFromString:@"07/11/1986 08:23am"];

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
    STAssertEqualObjects([salt_lake mt_inTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]], los_angeles, nil);
}





#pragma mark - INTERNATIONAL WEEK TESTS

- (void)test_firstDayOfWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];

    [NSDate mt_setFirstDayOfWeek:1];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Sun", nil);

    [NSDate mt_setFirstDayOfWeek:2];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Mon", nil);

    [NSDate mt_setFirstDayOfWeek:3];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Tue", nil);

    [NSDate mt_setFirstDayOfWeek:4];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Wed", nil);

    [NSDate mt_setFirstDayOfWeek:5];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Thu", nil);

    [NSDate mt_setFirstDayOfWeek:6];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Fri", nil);

    [NSDate mt_setFirstDayOfWeek:7];
    STAssertEqualObjects([[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle], @"Sat", nil);

    [NSDate mt_setFirstDayOfWeek:1];
}

- (void)test_firstWeekOfYear
{
    NSDate *date = nil;

    // Jan 1st is a sunday
    date = [_formatter dateFromString:@"01/01/2012 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 52, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a monday
    date = [_formatter dateFromString:@"01/01/2001 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a tuesday
    date = [_formatter dateFromString:@"01/01/2002 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a wednesday
    date = [_formatter dateFromString:@"01/01/2003 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a thursday
    date = [_formatter dateFromString:@"01/01/2004 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a friday
    date = [_formatter dateFromString:@"01/01/2010 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 53, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

    // Jan 1st is a saturday
    date = [_formatter dateFromString:@"01/01/2011 12:00am"];

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([date mt_weekOfYear] == 52, nil);

    [NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([date mt_weekOfYear] == 1, nil);

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

    STAssertEqualObjects(saltLake, seattle, nil);

    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *septStartDenver = [_formatter dateFromString:@"09/01/2012 01:00:00am"];
    NSDate *septEndDenver = [_formatter dateFromString:@"10/01/2012 12:59:59am"];

    NSDate *losAngeles = [NSDate mt_dateFromYear:2012 month:9 day:20 hour:9 minute:49 second:11];

    STAssertEqualObjects([losAngeles mt_startOfCurrentMonth], septStartDenver, nil);

    STAssertEqualObjects([losAngeles mt_endOfCurrentMonth], septEndDenver, nil);

    STAssertTrue([losAngeles mt_daysInCurrentMonth] == 30, nil);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}





#pragma mark - COMMON DATE FORMATS

- (void)test_MTDatesFormatDefault
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
    NSString *string = @"Sat, Jun 09, 2007, 17:46:21";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatDefault], date, nil);
    NSString *formatted = [date mt_stringFromDateWithFormat:MTDatesFormatDefault localized:YES];
    STAssertTrue([self levenshteinDistanceWithString:formatted fromString:formatted] < 2, nil);
}

- (void)test_MTDatesFormatShortDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"6/9/07";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortDate], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatShortDate localized:YES], string, nil);
}

- (void)test_MTDatesFormatMediumDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Jun 9, 2007";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumDate], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatMediumDate localized:YES], string, nil);
}

- (void)test_MTDatesFormatLongDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"June 9, 2007";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongDate], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatLongDate localized:YES], string, nil);
}

- (void)test_MTDatesFormatFullDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Saturday, June 9, 2007";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatFullDate], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatFullDate localized:YES], string, nil);
}

- (void)test_MTDatesFormatShortTime
{
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46 PM";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortTime], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatShortTime localized:YES], string, nil);
}

- (void)test_MTDatesFormatMediumTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumTime], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatMediumTime localized:YES], string, nil);
}

- (void)test_MTDatesFormatLongTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa zzz";
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm EST", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM EST";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongTime], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatLongTime localized:YES], string, nil);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}

- (void)test_MTDatesFormatISODate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"2007-06-09";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODate], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISODate localized:NO], string, nil);
}

- (void)test_MTDatesFormatISOTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", (int)[self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"17:46:21";

    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISOTime], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISOTime localized:YES], string, nil);
}

- (void)test_MTDatesFormatISODateTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];

    NSString *string = @"2007-06-09 17:46:21";
    STAssertEqualObjects([NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODateTime], date, nil);
    STAssertEqualObjects([date mt_stringFromDateWithFormat:MTDatesFormatISODateTime localized:NO], string, nil);
}

- (void)test_MTDatesBlockInvoke {
    dispatch_queue_t queue = dispatch_queue_create("mtdates-test", NULL);
    dispatch_async(queue, ^{
        NSDate * date = [NSDate mt_dateFromYear:2013 month:1 day:1];
        STAssertNotNil(date, nil);
    });
    dispatch_release(queue);
}

- (void)test_japaneseCalendar
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];

    [NSDate mt_setCalendarIdentifier:NSJapaneseCalendar];

    STAssertTrue([date mt_year]         == 19, nil);
    STAssertTrue([date mt_monthOfYear]  == 6, nil);
    STAssertTrue([date mt_dayOfMonth]   == 9, nil);

    NSDate *date1 = [date mt_startOfCurrentMonth];
    STAssertTrue([date1 mt_year]         == 19, nil);
    STAssertTrue([date1 mt_monthOfYear]  == 6, nil);
    STAssertTrue([date1 mt_dayOfMonth]   == 1, nil);

    NSDate *date2 = [date mt_startOfCurrentYear];
    STAssertTrue([date2 mt_year]         == 19, nil);
    STAssertTrue([date2 mt_monthOfYear]  == 1, nil);
    STAssertTrue([date2 mt_dayOfMonth]   == 1, nil);

    [NSDate mt_setCalendarIdentifier:NSGregorianCalendar];
}




#pragma mark - Private

// calculate the distance between two string treating them eash as a single word
// credit: https://github.com/pigoz/imal/blob/master/NSString+Levenshtein.m

int minimum(int a,int b,int c)
{
 NSInteger min=a;
	if(b<min)
		min=b;
	if(c<min)
		min=c;
	return min;
}


- (int)levenshteinDistanceWithString:(NSString *)string fromString:(NSString *)string2
{
 NSInteger *d; // distance vector
 NSInteger i,j,k; // indexes
 NSInteger cost, distance;

	NSUInteger n = [string2 length];
	NSUInteger m = [string length];

	if( n!=0 && m!=0 ){

		d = malloc( sizeof(int) * (++n) * (++m) );

		for( k=0 ; k<n ; k++ )
			d[k] = k;
		for( k=0 ; k<m ; k++ )
			d[k*n] = k;

		for( i=1; i<n ; i++ ) {
			for( j=1 ;j<m ; j++ ) {
				if( [string2 characterAtIndex:i-1]  == [string characterAtIndex:j-1])
					cost = 0;
				else
					cost = 1;
				d[j*n+i]=minimum(d[(j-1)*n+i]+1,d[j*n+i-1]+1,d[(j-1)*n+i-1]+cost);
			}
		}
		distance = d[n*m-1];
		free(d);
		return distance;
	}
    
	return -1; // error
}

@end
