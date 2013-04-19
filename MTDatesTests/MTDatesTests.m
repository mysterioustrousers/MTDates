//
//  MTDatesTests.m
//  MTDatesTests
//
//  Created by Adam Kirk on 8/9/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "MTDatesTests.h"
#import "NSDate+MTDates.h"

@implementation MTDatesTests

- (void)setUp
{
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"MM/dd/yyyy hh:mma";

    _GMTFormatter = [[NSDateFormatter alloc] init];
    _GMTFormatter.dateFormat = @"MM/dd/yyyy hh:mma";
    _GMTFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];

    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}




- (NSInteger)dateFormatterDefaultYear {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
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
    STAssertTrue([date isEqualToDate:date2], nil);

    NSDate *date3 = [NSDate mt_dateFromISOString:@"1986-07-11T17:29:00Z"];
    STAssertTrue([date isEqualToDate:date3], nil);

    NSDate *date4 = [NSDate mt_dateFromISOString:@"1986-07-11 17:29:00 +0000"];
    STAssertTrue([date isEqualToDate:date4], nil);
}

- (void)test_dateFromString_usingFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [NSDate mt_dateFromString:@"11 July 1986 11-29-am" usingFormat:@"dd MMMM yyyy hh'-'mm'-'a"];
    STAssertTrue([date isEqualToDate:date2], nil);
}

- (void)test_dateFromYear_month_day
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 month:7 day:11] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_month_day_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_month_day_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 month:7 day:11 hour:11 minute:29 second:0] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekday
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 week:28 weekday:6] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekday_hour_minute
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekday_hour_minute_second
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29 second:0] isEqualToDate:date], nil);
}

- (void)test_dateByAddingYears_months_weeks_days_hours_minutes_seconds
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/05/1982 10:05am"];
    STAssertTrue([[date2 mt_dateByAddingYears:4 months:5 weeks:0 days:6 hours:1 minutes:24 seconds:0] isEqualToDate:date], nil);

    NSDate *date3 = [_formatter dateFromString:@"06/27/1986 10:05am"];
    STAssertTrue([[date3 mt_dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0] isEqualToDate:date], nil);
}

- (void)test_startOfToday
{
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [date mt_components];
    STAssertTrue([[NSDate mt_startOfToday] isEqualToDate:[NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]], nil);
}

- (void)test_startOfYesterday
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-86400];
    NSDateComponents *comps = [date mt_components];
    STAssertTrue([[NSDate mt_startOfYesterday] isEqualToDate:[NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]], nil);
}

- (void)test_startOfTomorrow
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:86400];
    NSDateComponents *comps = [date mt_components];
    STAssertTrue([[NSDate mt_startOfTomorrow] isEqualToDate:[NSDate mt_dateFromYear:[comps year] month:[comps month] day:[comps day]]], nil);
}

- (void)test_endOfToday
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:-1];
    STAssertTrue([[NSDate mt_endOfToday] isEqualToDate:date], nil);
}

- (void)test_endOfTomorrow
{
    NSDate *date = [[NSDate mt_startOfTomorrow] dateByAddingTimeInterval:86400-1];
    STAssertTrue([[NSDate mt_endOfTomorrow] isEqualToDate:date], nil);
}

- (void)test_endOfYesterday
{
    NSDate *date = [[NSDate mt_startOfToday] dateByAddingTimeInterval:-1];
    STAssertTrue([[NSDate mt_endOfYesterday] isEqualToDate:date], nil);
}


#pragma mark - SYMBOLS

- (void)test_shortWeekdaySymbols
{
    STAssertTrue([NSDate mt_shortWeekdaySymbols].count == 7, nil);
}

- (void)test_weekdaySymbols
{
    STAssertTrue([NSDate mt_shortWeekdaySymbols].count == 7, nil);
}

- (void)test_veryShortWeekdaySymbols
{
    STAssertTrue([NSDate mt_shortWeekdaySymbols].count == 7, nil);
}

- (void)test_shortMonthlySymbols
{
    STAssertTrue([NSDate mt_shortMonthlySymbols].count == 12, nil);
}

- (void)test_monthlySymbols
{
    STAssertTrue([NSDate mt_shortMonthlySymbols].count == 12, nil);
}

- (void)test_veryShortMonthlySymbols
{
    STAssertTrue([NSDate mt_shortMonthlySymbols].count == 12, nil);
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
    STAssertTrue([[date mt_startOfPreviousYear] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1986 12:00am"];
    STAssertTrue([[date mt_startOfCurrentYear] isEqualToDate:date2], nil);
}

- (void)test_startOfNextYear
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"01/01/1987 12:00am"];
    STAssertTrue([[date mt_startOfNextYear] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1985 11:59:59pm"];
    STAssertTrue([[date mt_endOfPreviousYear] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfCurrentYear] isEqualToDate:date2], nil);
}

- (void)test_endOfNextYear
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfCurrentYear] isEqualToDate:date2], nil);
}


- (void)test_oneYearPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1985 11:29am"];
    STAssertTrue([[date mt_oneYearPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneYearNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1987 11:29am"];
    STAssertTrue([[date mt_oneYearNext] isEqualToDate:date2], nil);
}


- (void)test_dateYearsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1982 11:29am"];
    STAssertTrue([[date mt_dateYearsBefore:4] isEqualToDate:date2], nil);
}

- (void)test_dateYearsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
    STAssertTrue([[date mt_dateYearsAfter:8] isEqualToDate:date2], nil);
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
    STAssertTrue([[date mt_startOfPreviousMonth] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/01/1986 12:00am"];
    STAssertTrue([[date mt_startOfCurrentMonth] isEqualToDate:date2], nil);
}

- (void)test_startOfNextMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/01/1986 12:00am"];
    STAssertTrue([[date mt_startOfNextMonth] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"06/30/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfPreviousMonth] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/31/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfCurrentMonth] isEqualToDate:date2], nil);
}

- (void)test_endOfNextMonth
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"08/31/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfNextMonth] isEqualToDate:date2], nil);
}


- (void)test_oneMonthPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"06/11/1986 11:29am"];
    STAssertTrue([[date mt_oneMonthPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneMonthNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"08/11/1986 11:29am"];
    STAssertTrue([[date mt_oneMonthNext] isEqualToDate:date2], nil);
}


- (void)test_dateMonthsBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"03/11/1986 11:29am"];
    STAssertTrue([[date mt_dateMonthsBefore:4] isEqualToDate:date2], nil);
}

- (void)test_dateMonthsAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
    STAssertTrue([[date mt_dateMonthsAfter:3] isEqualToDate:date2], nil);
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
    STAssertTrue([[date mt_startOfPreviousWeek] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/06/1986 12:00am"];
    STAssertTrue([[date mt_startOfCurrentWeek] isEqualToDate:date2], nil);
}

- (void)test_startOfNextWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/13/1986 12:00am"];
    STAssertTrue([[date mt_startOfNextWeek] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfPreviousWeek] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfCurrentWeek] isEqualToDate:date2], nil);
}

- (void)test_endOfNextWeek
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/19/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfNextWeek] isEqualToDate:date2], nil);
}


- (void)test_oneWeekPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/04/1986 11:29am"];
    STAssertTrue([[date mt_oneWeekPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneWeekNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/18/1986 11:29am"];
    STAssertTrue([[date mt_oneWeekNext] isEqualToDate:date2], nil);
}


- (void)test_dateWeeksBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
    STAssertTrue([[date mt_dateWeeksBefore:22] isEqualToDate:date2], nil);
}

- (void)test_dateWeeksAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"11/21/1986 11:29am"];
    STAssertTrue([[date mt_dateWeeksAfter:19] isEqualToDate:date2], nil);
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
    STAssertTrue([[date mt_startOfPreviousDay] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
    STAssertTrue([[date mt_startOfCurrentDay] isEqualToDate:date2], nil);
}

- (void)test_startOfNextDay
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:00am"];
    STAssertTrue([[date mt_startOfNextDay] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfPreviousDay] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfCurrentDay] isEqualToDate:date2], nil);
}

- (void)test_endOfNextDay
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
    STAssertTrue([[date mt_endOfNextDay] isEqualToDate:date2], nil);
}


- (void)test_oneDayPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:29am"];
    STAssertTrue([[date mt_oneDayPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneDayNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:29am"];
    STAssertTrue([[date mt_oneDayNext] isEqualToDate:date2], nil);
}


- (void)test_dateDaysBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:29am"];
    STAssertTrue([[date mt_dateDaysBefore:6] isEqualToDate:date2], nil);
}

- (void)test_dateDaysAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
    STAssertTrue([[date mt_dateDaysAfter:4] isEqualToDate:date2], nil);
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
    STAssertTrue([[date mt_startOfPreviousHour] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:00am"];
    STAssertTrue([[date mt_startOfCurrentHour] isEqualToDate:date2], nil);
}

- (void)test_startOfNextHour
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00pm"];
    STAssertTrue([[date mt_startOfNextHour] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:59:59am"];
    STAssertTrue([[date mt_endOfPreviousHour] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59am"];
    STAssertTrue([[date mt_endOfCurrentHour] isEqualToDate:date2], nil);
}

- (void)test_endOfNextHour
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:59:59pm"];
    STAssertTrue([[date mt_endOfNextHour] isEqualToDate:date2], nil);
}


- (void)test_oneHourPrevious
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:29am"];
    STAssertTrue([[date mt_oneHourPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneHourNext
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:29pm"];
    STAssertTrue([[date mt_oneHourNext] isEqualToDate:date2], nil);
}


- (void)test_dateHoursBefore
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29am"];
    STAssertTrue([[date mt_dateHoursBefore:6] isEqualToDate:date2], nil);
}

- (void)test_dateHoursAfter
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29pm"];
    STAssertTrue([[date mt_dateHoursAfter:6] isEqualToDate:date2], nil);
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
    BOOL match = [s isEqualToString:@"July 11, 1986 11:00 PM"] || [s isEqualToString:@"July 11, 1986, 11:00 PM"];
    STAssertTrue(match, nil);

    [NSDate mt_setFormatterTimeStyle:NSDateFormatterNoStyle];
    STAssertTrue([[date mt_stringValue] isEqualToString:@"July 11, 1986"], nil);
}

- (void)test_settingDateFormattingTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    [NSDate mt_setFormatterTimeStyle:NSDateFormatterMediumStyle];

    NSString *s = [date mt_stringValue];
    BOOL match = [s isEqualToString:@"July 11, 1986 11:00:00 PM"] || [s isEqualToString:@"July 11, 1986, 11:00:00 PM"];
    STAssertTrue(match, nil);

    [NSDate mt_setFormatterDateStyle:NSDateFormatterNoStyle];
    STAssertTrue([[date mt_stringValue] isEqualToString:@"11:00:00 PM"], nil);
}

- (void)test_stringValueWithDateStyleTimeStyle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    NSString *s = [date mt_stringValueWithDateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterShortStyle];

    BOOL match = [s isEqualToString:@"Friday, July 11, 1986 11:00 PM"] || [s isEqualToString:@"Friday, July 11, 1986, 11:00 PM"];
    STAssertTrue(match, nil);
}

- (void)test_stringFromDateWithHourAndMinuteFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
    STAssertTrue([[date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour] isEqualToString:@"23:00"], nil);
    STAssertTrue([[date mt_stringFromDateWithHourAndMinuteFormat:MTDateHourFormat12Hour] isEqualToString:@"11:00 PM"], nil);
}

- (void)test_stringFromDatesShortMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithShortMonth] isEqualToString:@"Jul"], nil);
}

- (void)test_stringFromDatesFullMonth
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithFullMonth] isEqualToString:@"July"], nil);
}

- (void)test_stringWithAMPMSymbol
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithAMPMSymbol] isEqualToString:@"AM"], nil);
}

- (void)test_stringWithShortWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Fri"], nil);
}

- (void)test_stringWithFullWeekdayTitle
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithFullWeekdayTitle] isEqualToString:@"Friday"], nil);
}

- (void)test_stringFromDateWithFormat
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithFormat:@"MMM dd yyyy" localized:YES] isEqualToString:@"Jul 11, 1986"], nil);
}

- (void)test_stringFromDateWithISODateTime
{
    NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    STAssertTrue([[date mt_stringFromDateWithISODateTime] isEqualToString:@"1986-07-11 17:29:00 +0000"], nil);
}

- (void)test_stringFromDateWithGreatestComponentsForInterval
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
    STAssertTrue([[date mt_stringFromDateWithGreatestComponentsForSecondsPassed:3002] isEqualToString:@"50 minutes, 2 seconds after"], nil);
}

- (void)test_stringFromDateWithGreatestComponentsUntilDate
{
    NSDate *date1 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:33pm"];
    STAssertTrue([[date1 mt_stringFromDateWithGreatestComponentsUntilDate:date2] isEqualToString:@"In 1 day, 1 hour, 4 minutes"], nil);
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
    STAssertTrue([[salt_lake mt_inTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]] isEqualToDate:los_angeles], nil);
}





#pragma mark - INTERNATIONAL WEEK TESTS

- (void)test_firstDayOfWeek
{
    NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];

    [NSDate mt_setFirstDayOfWeek:1];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Sun"], nil);

    [NSDate mt_setFirstDayOfWeek:2];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Mon"], nil);

    [NSDate mt_setFirstDayOfWeek:3];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Tue"], nil);

    [NSDate mt_setFirstDayOfWeek:4];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Wed"], nil);

    [NSDate mt_setFirstDayOfWeek:5];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Thu"], nil);

    [NSDate mt_setFirstDayOfWeek:6];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Fri"], nil);

    [NSDate mt_setFirstDayOfWeek:7];
    STAssertTrue([[[date mt_startOfCurrentWeek] mt_stringFromDateWithShortWeekdayTitle] isEqualToString:@"Sat"], nil);

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

    STAssertTrue([saltLake isEqualToDate:seattle], nil);

    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *septStartDenver = [_formatter dateFromString:@"09/01/2012 01:00:00am"];
    NSDate *septEndDenver = [_formatter dateFromString:@"10/01/2012 12:59:59am"];

    NSDate *losAngeles = [NSDate mt_dateFromYear:2012 month:9 day:20 hour:9 minute:49 second:11];

    STAssertTrue([[losAngeles mt_startOfCurrentMonth] isEqualToDate:septStartDenver], nil);

    STAssertTrue([[losAngeles mt_endOfCurrentMonth] isEqualToDate:septEndDenver], nil);

    STAssertTrue([losAngeles mt_daysInCurrentMonth] == 30, nil);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}





#pragma mark - COMMON DATE FORMATS

- (void)test_MTDatesFormatDefault
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
    NSString *string = @"Sat, Jun 09, 2007, 17:46:21";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatDefault] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatDefault localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatShortDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"6/9/07";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortDate] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatShortDate localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatMediumDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Jun 9, 2007";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumDate] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatMediumDate localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatLongDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"June 9, 2007";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongDate] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatLongDate localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatFullDate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"Saturday, June 9, 2007";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatFullDate] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatFullDate localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatShortTime
{
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46pm", [self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46 PM";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatShortTime] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatShortTime localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatMediumTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", [self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatMediumTime] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatMediumTime localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatLongTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa zzz";
    [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm EST", [self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"5:46:21 PM EST";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatLongTime] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatLongTime localized:YES] isEqualToString:string], nil);

    [NSDate mt_setTimeZone:[NSTimeZone defaultTimeZone]];
}

- (void)test_MTDatesFormatISODate
{
    NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
    NSString *string = @"2007-06-09";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODate] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatISODate localized:NO] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatISOTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSString *dateString = [NSString stringWithFormat:@"01/01/%d 05:46:21pm", [self dateFormatterDefaultYear]];
    NSDate *date = [_formatter dateFromString:dateString];
    NSString *string = @"17:46:21";

    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatISOTime] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatISOTime localized:YES] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatISODateTime
{
    _formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
    NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];

    NSString *string = @"2007-06-09 17:46:21";
    STAssertTrue([[NSDate mt_dateFromString:string usingFormat:MTDatesFormatISODateTime] isEqualToDate:date], nil);
    STAssertTrue([[date mt_stringFromDateWithFormat:MTDatesFormatISODateTime localized:NO] isEqualToString:string], nil);
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

@end
