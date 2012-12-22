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
    
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}



#pragma mark - CONSTRUCTORS

- (void)test_dateFromISOString 
{
	NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
    NSDate *date2 = [NSDate dateFromISOString:@"1986-07-11T17:29:00"];
	STAssertTrue([date isEqualToDate:date2], nil);
}

- (void)test_dateFromString_usingFormat
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [NSDate dateFromString:@"11 July 1986 11-29-am" usingFormat:@"dd MMMM yyyy hh'-'mm'-'a"];
	STAssertTrue([date isEqualToDate:date2], nil);
}

- (void)test_dateFromYear_month_day 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
	STAssertTrue([[NSDate dateFromYear:1986 month:7 day:11] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_month_day_hour_minute 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[NSDate dateFromYear:1986 month:7 day:11 hour:11 minute:29] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_month_day_hour_minute_second 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[NSDate dateFromYear:1986 month:7 day:11 hour:11 minute:29 second:0] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 12:00am"];
	STAssertTrue([[NSDate dateFromYear:1986 week:28 weekDay:6] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekDay_hour_minute 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[NSDate dateFromYear:1986 week:28 weekDay:6 hour:11 minute:29] isEqualToDate:date], nil);
}

- (void)test_dateFromYear_week_weekDay_hour_minute_second 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[NSDate dateFromYear:1986 week:28 weekDay:6 hour:11 minute:29 second:0] isEqualToDate:date], nil);
}

- (void)test_dateByAddingYears_months_weeks_days_hours_minutes_seconds 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"02/05/1982 10:05am"];
	STAssertTrue([[date2 dateByAddingYears:4 months:5 weeks:0 days:6 hours:1 minutes:24 seconds:0] isEqualToDate:date], nil);

	NSDate *date3 = [_formatter dateFromString:@"06/27/1986 10:05am"];
	STAssertTrue([[date3 dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0] isEqualToDate:date], nil);
}




#pragma mark - SYMBOLS

- (void)test_shortWeekdaySymbols 
{
	STAssertTrue([NSDate shortWeekdaySymbols].count == 7, nil);
}

- (void)test_weekdaySymbols 
{
	STAssertTrue([NSDate shortWeekdaySymbols].count == 7, nil);
}

- (void)test_veryShortWeekdaySymbols 
{
	STAssertTrue([NSDate shortWeekdaySymbols].count == 7, nil);
}

- (void)test_shortMonthlySymbols 
{
	STAssertTrue([NSDate shortMonthlySymbols].count == 12, nil);
}

- (void)test_monthlySymbols 
{
	STAssertTrue([NSDate shortMonthlySymbols].count == 12, nil);
}

- (void)test_veryShortMonthlySymbols 
{
	STAssertTrue([NSDate shortMonthlySymbols].count == 12, nil);
}





#pragma mark - COMPONENTS

- (void)test_year 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date year] == 1986, nil);
}

- (void)test_weekOfYear 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date weekOfYear] == 28, nil);
}

- (void)test_weekDayOfWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date weekDayOfWeek] == 6, nil);
}

- (void)test_monthOfYear 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date monthOfYear] == 7, nil);
}

- (void)test_dayOfMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date dayOfMonth] == 11, nil);
}

- (void)test_hourOfDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date hourOfDay] == 11, nil);
}

- (void)test_minuteOfHour 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date minuteOfHour] == 29, nil);
}

- (void)test_secondOfMinute 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
	STAssertTrue([date secondOfMinute] == 33, nil);
}

- (void)test_secondsIntoDay 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:33am"];
	STAssertTrue([date secondsIntoDay] == 41373, nil);
}





#pragma mark - RELATIVES


#pragma mark years

- (void)test_startOfPreviousYear 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"01/01/1985 12:00am"];
	STAssertTrue([[date startOfPreviousYear] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentYear 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"01/01/1986 12:00am"];
	STAssertTrue([[date startOfCurrentYear] isEqualToDate:date2], nil);
}

- (void)test_startOfNextYear 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"01/01/1987 12:00am"];
	STAssertTrue([[date startOfNextYear] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousYear 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"12/31/1985 11:59:59pm"];
	STAssertTrue([[date endOfPreviousYear] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentYear 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
	STAssertTrue([[date endOfCurrentYear] isEqualToDate:date2], nil);
}

- (void)test_endOfNextYear 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"12/31/1986 11:59:59pm"];
	STAssertTrue([[date endOfCurrentYear] isEqualToDate:date2], nil);
}


- (void)test_oneYearPrevious 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1985 11:29am"];
	STAssertTrue([[date oneYearPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneYearNext 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1987 11:29am"];
	STAssertTrue([[date oneYearNext] isEqualToDate:date2], nil);
}


- (void)test_dateYearsBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1982 11:29am"];
	STAssertTrue([[date dateYearsBefore:4] isEqualToDate:date2], nil);
}

- (void)test_dateYearsAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
	STAssertTrue([[date dateYearsAfter:8] isEqualToDate:date2], nil);
}


- (void)test_yearsSinceDate 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
	STAssertTrue([date2 yearsSinceDate:date] == 8, nil);
}


- (void)test_yearsUntilDate
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1994 11:29am"];
	STAssertTrue([date yearsUntilDate:date2] == 8, nil);
}


#pragma mark months

- (void)test_startOfPreviousMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"06/01/1986 12:00am"];
	STAssertTrue([[date startOfPreviousMonth] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/01/1986 12:00am"];
	STAssertTrue([[date startOfCurrentMonth] isEqualToDate:date2], nil);
}

- (void)test_startOfNextMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"08/01/1986 12:00am"];
	STAssertTrue([[date startOfNextMonth] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousMonth 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"06/30/1986 11:59:59pm"];
	STAssertTrue([[date endOfPreviousMonth] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentMonth 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/31/1986 11:59:59pm"];
	STAssertTrue([[date endOfCurrentMonth] isEqualToDate:date2], nil);
}

- (void)test_endOfNextMonth 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"08/31/1986 11:59:59pm"];
	STAssertTrue([[date endOfNextMonth] isEqualToDate:date2], nil);
}


- (void)test_oneMonthPrevious 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"06/11/1986 11:29am"];
	STAssertTrue([[date oneMonthPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneMonthNext 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"08/11/1986 11:29am"];
	STAssertTrue([[date oneMonthNext] isEqualToDate:date2], nil);
}


- (void)test_dateMonthsBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"03/11/1986 11:29am"];
	STAssertTrue([[date dateMonthsBefore:4] isEqualToDate:date2], nil);
}

- (void)test_dateMonthsAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
	STAssertTrue([[date dateMonthsAfter:3] isEqualToDate:date2], nil);
}


- (void)test_monthsSinceDate 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
	STAssertTrue([date2 monthsSinceDate:date] == 3, nil);
}


- (void)test_monthsUntilDate
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"10/11/1986 11:29am"];
	STAssertTrue([date monthsUntilDate:date2] == 3, nil);
}



#pragma mark weeks

- (void)test_startOfPreviousWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"06/29/1986 12:00am"];
	STAssertTrue([[date startOfPreviousWeek] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/06/1986 12:00am"];
	STAssertTrue([[date startOfCurrentWeek] isEqualToDate:date2], nil);
}

- (void)test_startOfNextWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/13/1986 12:00am"];
	STAssertTrue([[date startOfNextWeek] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousWeek 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:59:59pm"];
	STAssertTrue([[date endOfPreviousWeek] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentWeek 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
	STAssertTrue([[date endOfCurrentWeek] isEqualToDate:date2], nil);
}

- (void)test_endOfNextWeek 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/19/1986 11:59:59pm"];
	STAssertTrue([[date endOfNextWeek] isEqualToDate:date2], nil);
}


- (void)test_oneWeekPrevious 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/04/1986 11:29am"];
	STAssertTrue([[date oneWeekPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneWeekNext 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/18/1986 11:29am"];
	STAssertTrue([[date oneWeekNext] isEqualToDate:date2], nil);
}


- (void)test_dateWeeksBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
	STAssertTrue([[date dateWeeksBefore:22] isEqualToDate:date2], nil);
}

- (void)test_dateWeeksAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"11/21/1986 11:29am"];
	STAssertTrue([[date dateWeeksAfter:19] isEqualToDate:date2], nil);
}


- (void)test_weeksSinceDate 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
	STAssertTrue([date weeksSinceDate:date2] == 22, nil);
}


- (void)test_weeksUntilDate
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"02/07/1986 11:29am"];
	STAssertTrue([date2 weeksUntilDate:date] == 22, nil);
}


#pragma mark days

- (void)test_startOfPreviousDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/10/1986 12:00am"];
	STAssertTrue([[date startOfPreviousDay] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
	STAssertTrue([[date startOfCurrentDay] isEqualToDate:date2], nil);
}

- (void)test_startOfNextDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:00am"];
	STAssertTrue([[date startOfNextDay] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousDay 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:59:59pm"];
	STAssertTrue([[date endOfPreviousDay] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentDay 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59pm"];
	STAssertTrue([[date endOfCurrentDay] isEqualToDate:date2], nil);
}

- (void)test_endOfNextDay 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:59:59pm"];
	STAssertTrue([[date endOfNextDay] isEqualToDate:date2], nil);
}


- (void)test_oneDayPrevious 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/10/1986 11:29am"];
	STAssertTrue([[date oneDayPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneDayNext 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/12/1986 11:29am"];
	STAssertTrue([[date oneDayNext] isEqualToDate:date2], nil);

}


- (void)test_dateDaysBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/05/1986 11:29am"];
	STAssertTrue([[date dateDaysBefore:6] isEqualToDate:date2], nil);
}

- (void)test_dateDaysAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
	STAssertTrue([[date dateDaysAfter:4] isEqualToDate:date2], nil);
}


- (void)test_daysSinceDate 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
	STAssertTrue([date2 daysSinceDate:date] == 4, nil);
}


- (void)test_daysUntilDate
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/15/1986 11:29am"];
	STAssertTrue([date daysUntilDate:date2] == 4, nil);
}



#pragma mark hours

- (void)test_startOfPreviousHour 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:00am"];
	STAssertTrue([[date startOfPreviousHour] isEqualToDate:date2], nil);
}

- (void)test_startOfCurrentHour 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:00am"];
	STAssertTrue([[date startOfCurrentHour] isEqualToDate:date2], nil);
}

- (void)test_startOfNextHour 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00pm"];
	STAssertTrue([[date startOfNextHour] isEqualToDate:date2], nil);
}


- (void)test_endOfPreviousHour 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:59:59am"];
	STAssertTrue([[date endOfPreviousHour] isEqualToDate:date2], nil);
}

- (void)test_endOfCurrentHour 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:59:59am"];
	STAssertTrue([[date endOfCurrentHour] isEqualToDate:date2], nil);
}

- (void)test_endOfNextHour 
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:59:59pm"];
	STAssertTrue([[date endOfNextHour] isEqualToDate:date2], nil);
}


- (void)test_oneHourPrevious 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 10:29am"];
	STAssertTrue([[date oneHourPrevious] isEqualToDate:date2], nil);
}

- (void)test_oneHourNext 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:29pm"];
	STAssertTrue([[date oneHourNext] isEqualToDate:date2], nil);
}


- (void)test_dateHoursBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29am"];
	STAssertTrue([[date dateHoursBefore:6] isEqualToDate:date2], nil);
}

- (void)test_dateHoursAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 05:29pm"];
	STAssertTrue([[date dateHoursAfter:6] isEqualToDate:date2], nil);
}


- (void)test_hoursSinceDate 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertTrue([date hoursSinceDate:date2] == 4, nil);
}


- (void)test_hoursUntilDate
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertTrue([date2 hoursUntilDate:date] == 4, nil);
}



#pragma mark - COMPARES

- (void)test_isAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertTrue([date isAfter:date2], nil);
}

- (void)test_isBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertTrue([date2 isBefore:date], nil);
}

- (void)test_isOnOrAfter 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date2 isOnOrAfter:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:30am"];
	STAssertTrue([date3 isOnOrAfter:date], nil);
}

- (void)test_isOnOrBefore 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([date2 isOnOrBefore:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"07/11/1986 11:28am"];
	STAssertTrue([date3 isOnOrBefore:date], nil);
}

- (void)test_isWithinSameMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/28/1986 07:29am"];
	STAssertTrue([date2 isWithinSameMonth:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"08/01/1986 07:29am"];
	STAssertFalse([date3 isWithinSameMonth:date], nil);
	NSDate *date4 = [_formatter dateFromString:@"06/01/1986 07:29am"];
	STAssertFalse([date4 isWithinSameMonth:date], nil);
}

- (void)test_isWithinSameWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/12/1986 07:29am"];
	STAssertTrue([date2 isWithinSameWeek:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"07/13/1986 07:29am"];
	STAssertFalse([date3 isWithinSameWeek:date], nil);
	NSDate *date4 = [_formatter dateFromString:@"06/05/1986 07:29am"];
	STAssertFalse([date4 isWithinSameWeek:date], nil);
}

- (void)test_isWithinSameDay 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertTrue([date2 isWithinSameDay:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"07/12/1986 12:00am"];
	STAssertFalse([date3 isWithinSameDay:date], nil);
	NSDate *date4 = [_formatter dateFromString:@"07/10/1986 07:29am"];
	STAssertFalse([date4 isWithinSameDay:date], nil);
}

- (void)test_isWithinSameHour 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 11:07am"];
	STAssertTrue([date2 isWithinSameHour:date], nil);
	NSDate *date3 = [_formatter dateFromString:@"07/11/1986 12:00am"];
	STAssertFalse([date3 isWithinSameHour:date], nil);
	NSDate *date4 = [_formatter dateFromString:@"07/11/1986 07:29am"];
	STAssertFalse([date4 isWithinSameHour:date], nil);
}





#pragma mark - STRINGS

- (void)test_stringFromDateWithHourAndMinuteFormat
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:00pm"];
	STAssertTrue([[date stringFromDateWithHourAndMinuteFormat:MTDateHourFormat24Hour] isEqualToString:@"23:00"], nil);
	STAssertTrue([[date stringFromDateWithHourAndMinuteFormat:MTDateHourFormat12Hour] isEqualToString:@"11:00PM"], nil);
}

- (void)test_stringFromDatesShortMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithShortMonth] isEqualToString:@"Jul"], nil);
}

- (void)test_stringFromDatesFullMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithFullMonth] isEqualToString:@"July"], nil);
}

- (void)test_stringWithAMPMSymbol 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithAMPMSymbol] isEqualToString:@"AM"], nil);
}

- (void)test_stringWithShortWeekdayTitle 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithShortWeekdayTitle] isEqualToString:@"Fri"], nil);
}

- (void)test_stringWithFullWeekdayTitle 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithFullWeekdayTitle] isEqualToString:@"Friday"], nil);
}

- (void)test_stringFromDateWithFormat 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithFormat:@"MMM dd yyyy"] isEqualToString:@"Jul 11 1986"], nil);
}

- (void)test_stringFromDateWithISODateTime 
{
	NSDate *date = [_GMTFormatter dateFromString:@"07/11/1986 5:29pm"];
	STAssertTrue([[date stringFromDateWithISODateTime] isEqualToString:@"1986-07-11T17:29:00Z"], nil);
}

- (void)test_stringFromDateWithGreatestComponentsForInterval 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 11:29am"];
	STAssertTrue([[date stringFromDateWithGreatestComponentsForSecondsPassed:3002] isEqualToString:@"50 minutes, 2 seconds after"], nil);
}

- (void)test_stringFromDateWithGreatestComponentsUntilDate
{
    NSDate *date1 = [_formatter dateFromString:@"07/11/1986 11:29am"];
    NSDate *date2 = [_formatter dateFromString:@"07/12/1986 12:33pm"];
    STAssertTrue([[date1 stringFromDateWithGreatestComponentsUntilDate:date2] isEqualToString:@"In 1 day, 1 hour, 4 minutes"], nil);
}





#pragma mark - MISC

- (void)test_datesCollectionFromDate_untilDate 
{
	NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
	NSDate *date2 = [_formatter dateFromString:@"07/11/1986 12:00am"];
	NSArray *dates = [NSDate datesCollectionFromDate:date untilDate:date2];
	STAssertTrue(dates.count == 9, nil);
}

- (void)test_hoursInCurrentDayAsDatesCollection 
{
	NSDate *date = [_formatter dateFromString:@"07/02/1986 12:00am"];
	STAssertTrue([date hoursInCurrentDayAsDatesCollection].count == 24, nil);
}

- (void)test_isInAM 
{
	NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
	STAssertTrue([date isInAM], nil);
}

- (void)test_isStartOfAnHour 
{
	NSDate *date = [_formatter dateFromString:@"07/02/1986 09:00am"];
	STAssertTrue([date isStartOfAnHour], nil);
}

- (void)test_weekdayStartOfCurrentMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
	STAssertTrue([date weekdayStartOfCurrentMonth] == 3, nil);
}

- (void)test_daysInCurrentMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
	STAssertTrue([date daysInCurrentMonth] == 31, nil);
}

- (void)test_daysInPreviousMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
	STAssertTrue([date daysInPreviousMonth] == 30, nil);
}

- (void)test_daysInNextMonth 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];
	STAssertTrue([date daysInNextMonth] == 31, nil);
}

- (void)test_toTimeZone
{
	[NSDate setTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];
	NSDate *salt_lake	= [_formatter dateFromString:@"07/11/1986 09:23am"];

	[NSDate setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
	NSDate *los_angeles	= [_formatter dateFromString:@"07/11/1986 08:23am"];

	[NSDate setTimeZone:[NSTimeZone defaultTimeZone]];
	STAssertTrue([[salt_lake inTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]] isEqualToDate:los_angeles], nil);
}





#pragma mark - INTERNATIONAL WEEK TESTS

- (void)test_firstDayOfWeek 
{
	NSDate *date = [_formatter dateFromString:@"07/11/1986 09:23am"];

	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Sun"], nil);

	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Mon"], nil);

	[NSDate setFirstDayOfWeek:3];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Tue"], nil);

	[NSDate setFirstDayOfWeek:4];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Wed"], nil);

	[NSDate setFirstDayOfWeek:5];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Thu"], nil);

	[NSDate setFirstDayOfWeek:6];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Fri"], nil);

	[NSDate setFirstDayOfWeek:7];
	STAssertTrue([[[date startOfCurrentWeek] stringFromDateWithShortWeekdayTitle] isEqualToString:@"Sat"], nil);

	[NSDate setFirstDayOfWeek:1];
}

- (void)test_firstWeekOfYear 
{
	NSDate *date = nil;

	// Jan 1st is a sunday
	date = [_formatter dateFromString:@"01/01/2012 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 52, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a monday
	date = [_formatter dateFromString:@"01/01/2001 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 1, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a tuesday
	date = [_formatter dateFromString:@"01/01/2002 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 1, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a wednesday
	date = [_formatter dateFromString:@"01/01/2003 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 1, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a thursday
	date = [_formatter dateFromString:@"01/01/2004 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 1, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a friday
	date = [_formatter dateFromString:@"01/01/2010 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 53, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// Jan 1st is a saturday
	date = [_formatter dateFromString:@"01/01/2011 12:00am"];

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setFirstDayOfWeek:2];
	STAssertTrue([date weekOfYear] == 52, nil);

	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
	STAssertTrue([date weekOfYear] == 1, nil);

	// reset for other tests
	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
	[NSDate setFirstDayOfWeek:1];
}



#pragma mark - TIMEZONE TESTS

- (void)test_changeTimezone
{
	[NSDate setTimeZone:[NSTimeZone timeZoneWithName:@"America/Denver"]];
	NSDate *saltLake = [NSDate dateFromYear:2012 month:9 day:18 hour:19 minute:29];

	[NSDate setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
	NSDate *seattle = [NSDate dateFromYear:2012 month:9 day:18 hour:18 minute:29];

	STAssertTrue([saltLake isEqualToDate:seattle], nil);

	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *septStartDenver = [_formatter dateFromString:@"09/01/2012 01:00:00am"];
	NSDate *septEndDenver = [_formatter dateFromString:@"10/01/2012 12:59:59am"];

	NSDate *losAngeles = [NSDate dateFromYear:2012 month:9 day:20 hour:9 minute:49 second:11];

	STAssertTrue([[losAngeles startOfCurrentMonth] isEqualToDate:septStartDenver], nil);

	STAssertTrue([[losAngeles endOfCurrentMonth] isEqualToDate:septEndDenver], nil);

	STAssertTrue([losAngeles daysInCurrentMonth] == 30, nil);

	[NSDate setTimeZone:[NSTimeZone defaultTimeZone]];
}





#pragma mark - COMMON DATE FORMATS

- (void)test_MTDatesFormatDefault
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
	NSString *string = @"Sat Jun 09 2007 17:46:21";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatDefault] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatDefault] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatShortDate
{
	NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
	NSString *string = @"6/9/07";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatShortDate] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatShortDate] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatMediumDate
{
	NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
	NSString *string = @"Jun 9, 2007";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatMediumDate] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatMediumDate] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatLongDate
{
	NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
	NSString *string = @"June 9, 2007";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatLongDate] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatLongDate] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatFullDate
{
	NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
	NSString *string = @"Saturday, June 9, 2007";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatFullDate] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatFullDate] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatShortTime
{
	NSDate *date = [_formatter dateFromString:@"01/01/2000 05:46pm"];
	NSString *string = @"5:46 PM";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatShortTime] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatShortTime] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatMediumTime
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"01/01/2000 05:46:21pm"];
	NSString *string = @"5:46:21 PM";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatMediumTime] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatMediumTime] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatLongTime
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa zzz";
	[NSDate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
	NSDate *date = [_formatter dateFromString:@"01/01/2000 05:46:21pm EST"];
	NSString *string = @"5:46:21 PM EST";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatLongTime] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatLongTime] isEqualToString:string], nil);

	[NSDate setTimeZone:[NSTimeZone defaultTimeZone]];
}

- (void)test_MTDatesFormatISODate
{
	NSDate *date = [_formatter dateFromString:@"06/09/2007 12:00am"];
	NSString *string = @"2007-06-09";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatISODate] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatISODate] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatISOTime
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"01/01/2000 05:46:21pm"];
	NSString *string = @"17:46:21";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatISOTime] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatISOTime] isEqualToString:string], nil);
}

- (void)test_MTDatesFormatISODateTime
{
	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
	NSDate *date = [_formatter dateFromString:@"06/09/2007 05:46:21pm"];
	NSString *string = @"2007-06-09T17:46:21";

	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatISODateTime] isEqualToDate:date], nil);
	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatISODateTime] isEqualToString:string], nil);
}

//- (void) test_MTDatesFormatISOUTCDateTime
//{
//	_formatter.dateFormat = @"MM/dd/yyyy hh:mm:ssa";
//	NSDate *date = [_formatter dateFromString:@"06/09/2007 10:46:21pm"];
//	NSString *string = @"2007-06-09T22:46:21Z";
//	NSDate *d = [NSDate dateFromString:string usingFormat:MTDatesFormatISOUTCDateTime];
//	STAssertTrue([[NSDate dateFromString:string usingFormat:MTDatesFormatISOUTCDateTime] isEqualToDate:date], nil);
//	STAssertTrue([[date stringFromDateWithFormat:MTDatesFormatISOUTCDateTime] isEqualToString:string], nil);
//}
//
//- (void)testThis {
//	_formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
//	NSDate *date = [_formatter dateFromString:@"2012-08-16 13:11:00"];
//}


@end
