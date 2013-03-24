//
//  NSDate+MTDates.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "NSDate+MTDates.h"


#define SECONDS_IN_MINUTE   60
#define MINUTES_IN_HOUR     60
#define DAYS_IN_WEEK        7
#define SECONDS_IN_HOUR     (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY        24
#define SECONDS_IN_DAY      (HOURS_IN_DAY * SECONDS_IN_HOUR)
#define SECONDS_IN_WEEK     (DAYS_IN_WEEK * SECONDS_IN_DAY)
#define SECONDS_IN_MONTH    (30 * SECONDS_IN_DAY)








@implementation NSDate (MTDates)

// These are NOT thread safe, so we must use a seperate one on each thread
static NSMutableDictionary          *__calendars            = nil;
static NSMutableDictionary          *__components           = nil;
static NSMutableDictionary          *__formatters           = nil;

static NSString                     *__calendarType         = nil;
static NSLocale                     *__locale               = nil;
static NSTimeZone                   *__timeZone             = nil;
static NSUInteger                   __firstWeekday          = 1;
static MTDateWeekNumberingSystem    __weekNumberingSystem   = 1;

static NSDateFormatterStyle         __dateStyle             = NSDateFormatterShortStyle;
static NSDateFormatterStyle         __timeStyle             = NSDateFormatterShortStyle;






+ (NSDateFormatter *)mt_sharedFormatter
{
    [self mt_prepareDefaults];

    if (!__formatters) __formatters = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSString *keyName           = [NSDate mt_threadIdentifier];
    NSDateFormatter *formatter  = __formatters[keyName];
    
    if (!formatter) {
        formatter           = [[NSDateFormatter alloc] init];
        formatter.calendar  = [self mt_calendar];
        formatter.locale    = __locale;
        formatter.timeZone  = __timeZone;
        [formatter setDateStyle:__dateStyle];
        [formatter setTimeStyle:__timeStyle];
        __formatters[keyName] = formatter;
    }

    return formatter;
}



#pragma mark - GLOBAL CONFIG

+ (void)mt_setCalendarIdentifier:(NSString *)identifier
{
    __calendarType = identifier;
    [self mt_reset];
}

+ (void)mt_setLocale:(NSLocale *)locale
{
    __locale = locale;
    [self mt_reset];
}

+ (void)mt_setTimeZone:(NSTimeZone *)timeZone
{
    __timeZone = timeZone;
    [self mt_reset];
}

+ (void)mt_setFirstDayOfWeek:(NSUInteger)firstDay
{
    __firstWeekday = firstDay;
    [self mt_reset];
}

+ (void)mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)system
{
    __weekNumberingSystem = system;
    [self mt_reset];
}




#pragma mark - CONSTRUCTORS

+ (NSDate *)mt_dateFromISOString:(NSString *)ISOString
{
    if (ISOString == nil || (NSNull *)ISOString == [NSNull null]) return nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    NSArray *formatsToTry = @[ @"yyyy-MM-dd HH:mm:ss ZZZ", @"yyyy-MM-dd HH:mm:ss Z", @"yyyy-MM-dd HH:mm:ss", @"yyyy-MM-dd'T'HH:mm:ss'Z'" ];

    NSDate *result = nil;
    for (NSString *format in formatsToTry) {
        [formatter setDateFormat:format];
        result = [formatter dateFromString:ISOString];
        if (result) break;
    }

    return result;
}

+ (NSDate *)mt_dateFromString:(NSString *)string usingFormat:(NSString *)format
{
    if (string == nil || (NSNull *)string == [NSNull null]) return nil;
    NSDateFormatter* formatter = [self mt_sharedFormatter];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return [self mt_dateFromYear:year
                           month:month
                             day:day
                            hour:[NSDate mt_minValueForUnit:NSHourCalendarUnit]
                          minute:[NSDate mt_minValueForUnit:NSMinuteCalendarUnit]];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    return [self mt_dateFromYear:year
                           month:month
                             day:day
                            hour:hour
                          minute:minute
                          second:[NSDate mt_minValueForUnit:NSSecondCalendarUnit]];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *comps = [NSDate mt_components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    return [[NSDate mt_calendar] dateFromComponents:comps];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday
{
    return [self mt_dateFromYear:year
                            week:week
                         weekday:weekday
                            hour:[NSDate mt_minValueForUnit:NSHourCalendarUnit]
                          minute:[NSDate mt_minValueForUnit:NSMinuteCalendarUnit]];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    return [self mt_dateFromYear:year
                            week:week
                         weekday:weekday
                            hour:hour
                          minute:minute
                          second:[NSDate mt_minValueForUnit:NSSecondCalendarUnit]];
}

+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *comps = [NSDate mt_components];
    [comps setYear:year];
    [comps setWeek:week];
    [comps setWeekday:weekday];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    return [[NSDate mt_calendar] dateFromComponents:comps];
}

- (NSDate *)mt_dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    NSDateComponents *comps = [NSDate mt_components];
    if (years)      [comps setYear:years];
    if (months)     [comps setMonth:months];
    if (weeks)      [comps setWeek:weeks];
    if (days)       [comps setDay:days];
    if (hours)      [comps setHour:hours];
    if (minutes)    [comps setMinute:minutes];
    if (seconds)    [comps setSecond:seconds];
    return [[NSDate mt_calendar] dateByAddingComponents:comps toDate:self options:0];
}

+ (NSDate *)mt_dateFromComponents:(NSDateComponents *)components
{
    return [[NSDate mt_calendar] dateFromComponents:components];
}





#pragma mark - SYMBOLS

+ (NSArray *)mt_shortWeekdaySymbols
{
    return [[NSDate mt_sharedFormatter] shortWeekdaySymbols];
}

+ (NSArray *)mt_weekdaySymbols
{
    return [[NSDate mt_sharedFormatter] weekdaySymbols];
}

+ (NSArray *)mt_veryShortWeekdaySymbols
{
    return [[NSDate mt_sharedFormatter] veryShortWeekdaySymbols];
}

+ (NSArray *)mt_shortMonthlySymbols
{
    return [[NSDate mt_sharedFormatter] shortMonthSymbols];
}

+ (NSArray *)mt_monthlySymbols
{
    return [[NSDate mt_sharedFormatter] monthSymbols];
}

+ (NSArray *)mt_veryShortMonthlySymbols
{
    return [[NSDate mt_sharedFormatter] veryShortMonthSymbols];
}




#pragma mark - COMPONENTS

- (NSUInteger)mt_year
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

- (NSUInteger)mt_weekOfYear
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSWeekOfYearCalendarUnit | NSYearCalendarUnit fromDate:self];
    return [comps weekOfYear];
}

- (NSUInteger)mt_weekOfMonth
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSWeekOfMonthCalendarUnit fromDate:self];
    return [components weekOfMonth];
}

- (NSUInteger)mt_weekdayOfWeek
{
    return [[NSDate mt_calendar] ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)mt_monthOfYear
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSUInteger)mt_dayOfMonth
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSUInteger)mt_hourOfDay
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

- (NSUInteger)mt_minuteOfHour
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}

- (NSUInteger)mt_secondOfMinute
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSSecondCalendarUnit fromDate:self];
    return [components second];
}

- (NSTimeInterval)mt_secondsIntoDay
{
    return [self timeIntervalSinceDate:[self mt_startOfCurrentDay]];
}

- (NSDateComponents *)mt_components
{
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [[NSDate mt_calendar] components:units fromDate:self];
}



#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)mt_startOfPreviousYear
{
    return [[self mt_startOfCurrentYear] mt_oneYearPrevious];
}

- (NSDate *)mt_startOfCurrentYear
{
    return [NSDate mt_dateFromYear:[self mt_year]
                             month:[NSDate mt_minValueForUnit:NSMonthCalendarUnit]
                               day:[NSDate mt_minValueForUnit:NSDayCalendarUnit]];
}

- (NSDate *)mt_startOfNextYear
{
    return [[self mt_startOfCurrentYear] mt_oneYearNext];
}


- (NSDate *)mt_endOfPreviousYear
{
    return [[self mt_endOfCurrentYear] mt_oneYearPrevious];
}

- (NSDate *)mt_endOfCurrentYear
{
    return [[self mt_startOfCurrentYear] mt_dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)mt_endOfNextYear
{
    return [[self mt_endOfCurrentYear] mt_oneYearNext];
}


- (NSDate *)mt_oneYearPrevious
{
    return [self mt_dateByAddingYears:-1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_oneYearNext
{
    return [self mt_dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSDate *)mt_dateYearsBefore:(NSUInteger)years
{
    return [self mt_dateByAddingYears:-years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_dateYearsAfter:(NSUInteger)years
{
    return [self mt_dateByAddingYears:years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)mt_yearsSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSYearCalendarUnit fromDate:date toDate:self options:0];
    NSInteger years = [comps year];
    return years;
}


- (NSInteger)mt_yearsUntilDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSYearCalendarUnit fromDate:self toDate:date options:0];
    NSInteger years = [comps year];
    return years;
}


#pragma mark months

- (NSDate *)mt_startOfPreviousMonth
{
    return [[self mt_startOfCurrentMonth] mt_oneMonthPrevious];
}

- (NSDate *)mt_startOfCurrentMonth
{
    return [NSDate mt_dateFromYear:[self mt_year]
                             month:[self mt_monthOfYear]
                               day:[NSDate mt_minValueForUnit:NSDayCalendarUnit]];
}

- (NSDate *)mt_startOfNextMonth
{
    return [[self mt_startOfCurrentMonth] mt_oneMonthNext];
}


- (NSDate *)mt_endOfPreviousMonth
{
    return [[self mt_endOfCurrentMonth] mt_oneMonthPrevious];
}

- (NSDate *)mt_endOfCurrentMonth
{
    return [[self mt_startOfCurrentMonth] mt_dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)mt_endOfNextMonth
{
    return [[self mt_endOfCurrentMonth] mt_oneMonthNext];
}


- (NSDate *)mt_oneMonthPrevious
{
    return [self mt_dateByAddingYears:0 months:-1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_oneMonthNext
{
    return [self mt_dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSDate *)mt_dateMonthsBefore:(NSUInteger)months
{
    return [self mt_dateByAddingYears:0 months:-months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_dateMonthsAfter:(NSUInteger)months
{
    return [self mt_dateByAddingYears:0 months:months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)mt_monthsSinceDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSMonthCalendarUnit fromDate:date toDate:self options:0];
    NSInteger months = [components month];
    return months;
}


- (NSInteger)mt_monthsUntilDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSMonthCalendarUnit fromDate:self toDate:date options:0];
    NSInteger months = [components month];
    return months;
}


#pragma mark weeks

- (NSDate *)mt_startOfPreviousWeek
{
    return [[self mt_startOfCurrentWeek] mt_oneWeekPrevious];
}

- (NSDate *)mt_startOfCurrentWeek
{
    NSInteger weekday = [self mt_weekdayOfWeek];
    NSDate *date = [self mt_dateDaysAfter:-(weekday - 1)];
    return [NSDate mt_dateFromYear:[date mt_year]
                             month:[date mt_monthOfYear]
                               day:[date mt_dayOfMonth]
                              hour:[NSDate mt_minValueForUnit:NSHourCalendarUnit]
                            minute:[NSDate mt_minValueForUnit:NSMinuteCalendarUnit]
                            second:[NSDate mt_minValueForUnit:NSSecondCalendarUnit]];
}

- (NSDate *)mt_startOfNextWeek
{
    return [[self mt_startOfCurrentWeek] mt_oneWeekNext];
}


- (NSDate *)mt_endOfPreviousWeek
{
    return [[self mt_endOfCurrentWeek] mt_oneWeekPrevious];
}

- (NSDate *)mt_endOfCurrentWeek
{
    return [[self mt_startOfCurrentWeek] mt_dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)mt_endOfNextWeek
{
    return [[self mt_endOfCurrentWeek] mt_oneWeekNext];
}


- (NSDate *)mt_oneWeekPrevious
{
    return [self mt_dateByAddingYears:0 months:0 weeks:-1 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_oneWeekNext
{
    return [self mt_dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_dateWeeksBefore:(NSUInteger)weeks
{
    return [self mt_dateByAddingYears:0 months:0 weeks:-weeks days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_dateWeeksAfter:(NSUInteger)weeks
{
    return [self mt_dateByAddingYears:0 months:0 weeks:weeks days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)mt_weeksSinceDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSWeekCalendarUnit fromDate:date toDate:self options:0];
    NSInteger weeks = [components week];
    return weeks;
}

- (NSInteger)mt_weeksUntilDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate mt_calendar] components:NSWeekCalendarUnit fromDate:self toDate:date options:0];
    NSInteger weeks = [components week];
    return weeks;
}


#pragma mark days

- (NSDate *)mt_startOfPreviousDay
{
    return [[self mt_startOfCurrentDay] mt_oneDayPrevious];
}

- (NSDate *)mt_startOfCurrentDay
{
    return [NSDate mt_dateFromYear:[self mt_year]
                             month:[self mt_monthOfYear]
                               day:[self mt_dayOfMonth]
                              hour:[NSDate mt_minValueForUnit:NSHourCalendarUnit]
                            minute:[NSDate mt_minValueForUnit:NSMinuteCalendarUnit]];
}

- (NSDate *)mt_startOfNextDay
{
    return [[self mt_startOfCurrentDay] mt_oneDayNext];
}


- (NSDate *)mt_endOfPreviousDay
{
    return [[self mt_endOfCurrentDay] mt_oneDayPrevious];
}

- (NSDate *)mt_endOfCurrentDay
{
    return [[self mt_startOfCurrentDay] mt_dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)mt_endOfNextDay
{
    return [[self mt_endOfCurrentDay] mt_oneDayNext];
}


- (NSDate *)mt_oneDayPrevious
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:-1 hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_oneDayNext
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:0];
}


- (NSDate *)mt_dateDaysBefore:(NSUInteger)days
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:-days hours:0 minutes:0 seconds:0];
}

- (NSDate *)mt_dateDaysAfter:(NSUInteger)days
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:days hours:0 minutes:0 seconds:0];
}


- (NSInteger)mt_daysSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSDayCalendarUnit fromDate:date toDate:self options:0];
    NSInteger days = [comps day];
    return days;
}


- (NSInteger)mt_daysUntilDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSDayCalendarUnit fromDate:self toDate:date options:0];
    NSInteger days = [comps day];
    return days;
}


#pragma mark hours

- (NSDate *)mt_startOfPreviousHour
{
    return [[self mt_startOfCurrentHour] mt_oneHourPrevious];
}

- (NSDate *)mt_startOfCurrentHour
{
    return [NSDate mt_dateFromYear:[self mt_year]
                             month:[self mt_monthOfYear]
                               day:[self mt_dayOfMonth]
                              hour:[self mt_hourOfDay]
                            minute:[NSDate mt_minValueForUnit:NSMinuteCalendarUnit]];
}

- (NSDate *)mt_startOfNextHour
{
    return [[self mt_startOfCurrentHour] mt_oneHourNext];
}


- (NSDate *)mt_endOfPreviousHour
{
    return [[self mt_endOfCurrentHour] mt_oneHourPrevious];
}

- (NSDate *)mt_endOfCurrentHour
{
    return [[self mt_startOfCurrentHour] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:-1];
}

- (NSDate *)mt_endOfNextHour
{
    return [[self mt_endOfCurrentHour] mt_oneHourNext];
}

- (NSDate *)mt_oneHourPrevious
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:-1 minutes:0 seconds:0];
}

- (NSDate *)mt_oneHourNext
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:0];
}


- (NSDate *)mt_dateHoursBefore:(NSUInteger)hours
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:-hours minutes:0 seconds:0];
}

- (NSDate *)mt_dateHoursAfter:(NSUInteger)hours
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:hours minutes:0 seconds:0];
}


- (NSInteger)mt_hoursSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSHourCalendarUnit fromDate:date toDate:self options:0];
    NSInteger hours = [comps hour];
    return hours;
}


- (NSInteger)mt_hoursUntilDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSHourCalendarUnit fromDate:self toDate:date options:0];
    NSInteger hours = [comps hour];
    return hours;
}

#pragma mark minutes

- (NSDate *)mt_startOfPreviousMinute
{
    return [[self mt_startOfCurrentMinute] mt_oneMinutePrevious];
}

- (NSDate *)mt_startOfCurrentMinute
{
    return [NSDate mt_dateFromYear:[self mt_year]
                             month:[self mt_monthOfYear]
                               day:[self mt_dayOfMonth]
                              hour:[self mt_hourOfDay]
                            minute:[self mt_minuteOfHour]
                            second:[NSDate mt_minValueForUnit:NSSecondCalendarUnit]];
}

- (NSDate *)mt_startOfNextMinute
{
    return [[self mt_startOfCurrentMinute] mt_oneMinuteNext];
}


- (NSDate *)mt_endOfPreviousMinute
{
    return [[self mt_endOfCurrentMinute] mt_oneMinutePrevious];
}

- (NSDate *)mt_endOfCurrentMinute
{
    return [[self mt_startOfCurrentMinute] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:-1];
}

- (NSDate *)mt_endOfNextMinute
{
    return [[self mt_endOfCurrentMinute] mt_oneMinuteNext];
}

- (NSDate *)mt_oneMinutePrevious
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-1 seconds:0];
}

- (NSDate *)mt_oneMinuteNext
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:0];
}


- (NSDate *)mt_dateMinutesBefore:(NSUInteger)minutes
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-minutes seconds:0];
}

- (NSDate *)mt_dateMinutesAfter:(NSUInteger)minutes
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0];
}


- (NSInteger)mt_minutesSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSMinuteCalendarUnit fromDate:date toDate:self options:0];
    NSInteger minutes = [comps minute];
    return minutes;
}


- (NSInteger)mt_minutesUntilDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSMinuteCalendarUnit fromDate:self toDate:date options:0];
    NSInteger minutes = [comps minute];
    return minutes;
}

#pragma mark seconds

- (NSDate *)mt_startOfPreviousSecond
{
    return [self dateByAddingTimeInterval:-1];
}

- (NSDate *)mt_startOfNextSecond
{
    return [self dateByAddingTimeInterval:1];
}

- (NSDate *)mt_oneSecondPrevious
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)mt_oneSecondNext
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}


- (NSDate *)mt_dateSecondsBefore:(NSUInteger)seconds
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-seconds];
}

- (NSDate *)mt_dateSecondsAfter:(NSUInteger)seconds
{
    return [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:seconds];
}


- (NSInteger)mt_secondsSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSSecondCalendarUnit fromDate:date toDate:self options:0];
    NSInteger seconds = [comps second];
    return seconds;
}


- (NSInteger)mt_secondsUntilDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSSecondCalendarUnit fromDate:self toDate:date options:0];
    NSInteger seconds = [comps second];
    return seconds;
}

#pragma mark - COMPARES

- (BOOL)mt_isAfter:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)mt_isBefore:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)mt_isOnOrAfter:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending || [date compare:self] == NSOrderedSame;
}

- (BOOL)mt_isOnOrBefore:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame;
}

- (BOOL)mt_isWithinSameYear:(NSDate *)date
{
    if ([self mt_year] == [date mt_year]) {
        return YES;
    }
    return NO;
}

- (BOOL)mt_isWithinSameMonth:(NSDate *)date
{
    if ([self mt_year] == [date mt_year] && [self mt_monthOfYear] == [date mt_monthOfYear]) {
        return YES;
    }
    return NO;
}

- (BOOL)mt_isWithinSameWeek:(NSDate *)date
{
    if ([self mt_isOnOrAfter:[date mt_startOfCurrentWeek]] && [self mt_isOnOrBefore:[date mt_endOfCurrentWeek]]) {
        return YES;
    }
    return NO;
}

- (BOOL)mt_isWithinSameDay:(NSDate *)date
{
    if ([self mt_year] == [date mt_year] && [self mt_monthOfYear] == [date mt_monthOfYear] && [self mt_dayOfMonth] == [date mt_dayOfMonth]) {
        return YES;
    }
    return NO;
}

- (BOOL)mt_isWithinSameHour:(NSDate *)date
{
    if ([self mt_year] == [date mt_year] && [self mt_monthOfYear] == [date mt_monthOfYear] && [self mt_dayOfMonth] == [date mt_dayOfMonth] && [self mt_hourOfDay] == [date mt_hourOfDay]) {
        return YES;
    }
    return NO;
}

- (BOOL)mt_isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 {
    if ([self mt_isOnOrAfter:date1] && [self mt_isOnOrBefore:date2])
        return YES;
    else if ([self mt_isOnOrAfter:date2] && [self mt_isOnOrBefore:date1])
        return YES;
    else
        return NO;
}




#pragma mark - STRINGS

+ (void)mt_setFormatterDateStyle:(NSDateFormatterStyle)style
{
    __dateStyle = style;
    [[NSDate mt_sharedFormatter] setDateStyle:style];
}

+ (void)mt_setFormatterTimeStyle:(NSDateFormatterStyle)style
{
    __timeStyle = style;
    [[NSDate mt_sharedFormatter] setTimeStyle:style];
}

- (NSString *)mt_stringValue
{
    return [[NSDate mt_sharedFormatter] stringFromDate:self];
}

- (NSString *)mt_stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    [[NSDate mt_sharedFormatter] setDateStyle:dateStyle];
    [[NSDate mt_sharedFormatter] setTimeStyle:timeStyle];
    NSString *str = [[NSDate mt_sharedFormatter] stringFromDate:self];
    [[NSDate mt_sharedFormatter] setDateStyle:__dateStyle];
    [[NSDate mt_sharedFormatter] setTimeStyle:__timeStyle];
    return str;
}

- (NSString *)mt_stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format {
    if (format == MTDateHourFormat24Hour) {
        return [self mt_stringFromDateWithFormat:@"HH:mm" localized:YES];
    }
    else {
        return [self mt_stringFromDateWithFormat:@"hh:mma" localized:YES];
    }
}

- (NSString *)mt_stringFromDateWithShortMonth {
    return [self mt_stringFromDateWithFormat:@"MMM" localized:YES];
}

- (NSString *)mt_stringFromDateWithFullMonth {
    return [self mt_stringFromDateWithFormat:@"MMMM" localized:YES];
}

- (NSString *)mt_stringFromDateWithAMPMSymbol {
    return [self mt_stringFromDateWithFormat:@"a" localized:NO];
}

- (NSString *)mt_stringFromDateWithShortWeekdayTitle {
    return [self mt_stringFromDateWithFormat:@"E" localized:YES];
}

- (NSString *)mt_stringFromDateWithFullWeekdayTitle {
    return [self mt_stringFromDateWithFormat:@"EEEE" localized:YES];
}

- (NSString *)mt_stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized
{
    NSDateFormatter *formatter = [NSDate mt_sharedFormatter];
    if (localized) format = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:__locale];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)mt_stringFromDateWithISODateTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* result = [formatter stringFromDate:self];
    return result;
}

- (NSString *)mt_stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval
{

    NSMutableString *s = [NSMutableString string];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)SECONDS_IN_MONTH);
    if (months > 0) {
        [s appendFormat:@"%ld months, ", (long)months];
        absInterval -= months * SECONDS_IN_MONTH;
    }

    NSInteger days = floor(absInterval / (float)SECONDS_IN_DAY);
    if (days > 0) {
        [s appendFormat:@"%ld days, ", (long)days];
        absInterval -= days * SECONDS_IN_DAY;
    }

    NSInteger hours = floor(absInterval / (float)SECONDS_IN_HOUR);
    if (hours > 0) {
        [s appendFormat:@"%ld hours, ", (long)hours];
        absInterval -= hours * SECONDS_IN_HOUR;
    }

    NSInteger minutes = floor(absInterval / (float)SECONDS_IN_MINUTE);
    if (minutes > 0) {
        [s appendFormat:@"%ld minutes, ", (long)minutes];
        absInterval -= minutes * SECONDS_IN_MINUTE;
    }

    NSInteger seconds = absInterval;
    if (seconds > 0) {
        [s appendFormat:@"%ld seconds, ", (long)seconds];
    }

    NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    return interval < 0 ? [NSString stringWithFormat:@"%@ before", preString] : [NSString stringWithFormat:@"%@ after", preString];
}

- (NSString *)mt_stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date
{
    NSMutableArray *s = [NSMutableArray array];
    NSTimeInterval interval = [date timeIntervalSinceDate:self];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)SECONDS_IN_MONTH);
    if (months > 0) {
        NSString *formatString = months == 1 ? @"%ld month" : @"%ld months";
        [s addObject:[NSString stringWithFormat:formatString, (long)months]];
        absInterval -= months * SECONDS_IN_MONTH;
    }

    NSInteger days = floor(absInterval / (float)SECONDS_IN_DAY);
    if (days > 0) {
        NSString *formatString = days == 1 ? @"%ld day" : @"%ld days";
        [s addObject:[NSString stringWithFormat:formatString, (long)days]];
        absInterval -= days * SECONDS_IN_DAY;
    }

    NSInteger hours = floor(absInterval / (float)SECONDS_IN_HOUR);
    if (hours > 0) {
        NSString *formatString = hours == 1 ? @"%ld hour" : @"%ld hours";
        [s addObject:[NSString stringWithFormat:formatString, (long)hours]];
        absInterval -= hours * SECONDS_IN_HOUR;
    }

    NSInteger minutes = floor(absInterval / (float)SECONDS_IN_MINUTE);
    if (minutes > 0) {
        NSString *formatString = minutes == 1 ? @"%ld minute" : @"%ld minutes";
        [s addObject:[NSString stringWithFormat:formatString, (long)minutes]];
    }

    NSString *preString = [s componentsJoinedByString:@", "];
    return interval < 0 ? [NSString stringWithFormat:@"%@ Ago", preString] : [NSString stringWithFormat:@"In %@", preString];
}





#pragma mark - MISC

+ (NSArray *)mt_datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate
{
    NSInteger days = [endDate mt_daysSinceDate:startDate];
    NSMutableArray *datesArray = [NSMutableArray array];

    for (int i = 0; i < days; i++) {
        [datesArray addObject:[startDate mt_dateDaysAfter:i]];
    }

    return [NSArray arrayWithArray:datesArray];
}

- (NSArray *)mt_hoursInCurrentDayAsDatesCollection
{
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 23; i >= 0; i--) {
        [hours addObject:[NSDate mt_dateFromYear:[self mt_year]
                                        month:[self mt_monthOfYear]
                                          day:[self mt_dayOfMonth]
                                         hour:i
                                       minute:0]];
    }
    return [NSArray arrayWithArray:hours];
}

- (BOOL)mt_isInAM
{
    return [self mt_hourOfDay] > 11 ? NO : YES;
}

- (BOOL)mt_isStartOfAnHour
{
    return [self mt_minuteOfHour] == [NSDate mt_minValueForUnit:NSHourCalendarUnit] && [self mt_secondOfMinute] == [NSDate mt_minValueForUnit:NSSecondCalendarUnit];
}

- (NSUInteger)mt_weekdayStartOfCurrentMonth
{
    return [[self mt_startOfCurrentMonth] mt_weekdayOfWeek];
}

- (NSUInteger)mt_daysInCurrentMonth
{
    return [[self mt_endOfCurrentMonth] mt_dayOfMonth];
}

- (NSUInteger)mt_daysInPreviousMonth
{
    return [[self mt_endOfPreviousMonth] mt_dayOfMonth];
}

- (NSUInteger)mt_daysInNextMonth
{
    return [[self mt_endOfNextMonth] mt_dayOfMonth];
}

- (NSDate *)mt_inTimeZone:(NSTimeZone *)timezone
{
    NSTimeZone *current             = __timeZone ? __timeZone : [NSTimeZone defaultTimeZone];
    NSTimeInterval currentOffset    = [current secondsFromGMTForDate:self];
    NSTimeInterval toOffset         = [timezone secondsFromGMTForDate:self];
    NSTimeInterval diff             = toOffset - currentOffset;
    return [self dateByAddingTimeInterval:diff];
}

+ (NSInteger)mt_minValueForUnit:(NSCalendarUnit)unit
{
    NSRange r = [[self mt_calendar] minimumRangeOfUnit:unit];
    return r.location;
}

+ (NSInteger)mt_maxValueForUnit:(NSCalendarUnit)unit
{
    NSRange r = [[self mt_calendar] maximumRangeOfUnit:unit];
    return r.length - 1;
}




#pragma mark - Private

+ (void)mt_prepareDefaults
{
    if (!__calendarType) {
        __calendarType = [(NSCalendar *)[NSCalendar currentCalendar] calendarIdentifier];
    }

    if (!__locale) {
        __locale = [NSLocale currentLocale];
    }

    if (!__timeZone) {
        __timeZone = [NSTimeZone localTimeZone];
    }
}

+ (NSCalendar *)mt_calendar
{
    [self mt_prepareDefaults];

    if (!__calendars) __calendars = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSString *keyName = [NSDate mt_threadIdentifier];
    NSCalendar *calendar = __calendars[keyName];

    if (!calendar) {
        calendar                            = [[NSCalendar alloc] initWithCalendarIdentifier:__calendarType];
        calendar.firstWeekday               = __firstWeekday;
        calendar.minimumDaysInFirstWeek     = (NSUInteger)__weekNumberingSystem;
        calendar.timeZone                   = __timeZone;
        __calendars[keyName] = calendar;
    }

    return calendar;
}

+ (NSDateComponents *)mt_components
{
    [self mt_prepareDefaults];

    if (!__components) __components = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSString *keyName = [NSDate mt_threadIdentifier];
    NSDateComponents *component = __components[keyName];

    if (!component) {
        component = [[NSDateComponents alloc] init];
        component.calendar = [self mt_calendar];
        if (__timeZone) component.timeZone = __timeZone;
        __components[keyName] = component;
    }

    [component setEra:NSUndefinedDateComponent];
    [component setYear:NSUndefinedDateComponent];
    [component setMonth:NSUndefinedDateComponent];
    [component setDay:NSUndefinedDateComponent];
    [component setHour:NSUndefinedDateComponent];
    [component setMinute:NSUndefinedDateComponent];
    [component setSecond:NSUndefinedDateComponent];
    [component setWeek:NSUndefinedDateComponent];
    [component setWeekday:NSUndefinedDateComponent];
    [component setWeekdayOrdinal:NSUndefinedDateComponent];
    [component setQuarter:NSUndefinedDateComponent];

    return component;
}

+ (void)mt_reset
{
    [__calendars removeAllObjects];
    [__components removeAllObjects];
    [__formatters removeAllObjects];
}

+ (NSString *)mt_threadIdentifier
{
    return [NSString stringWithFormat:@"%p", (void *) [NSThread currentThread]];
}


#if MTDATES_NO_PREFIX

#pragma mark - NO PREFIX

+ (NSDateFormatter *)sharedFormatter
{
    return [self mt_sharedFormatter];
}

#pragma mark - GLOBAL CONFIG (NO PREFIX)

+ (void)setCalendarIdentifier:(NSString *)identifier
{
    [self mt_setCalendarIdentifier:identifier];
}

+ (void)setLocale:(NSLocale *)locale
{
    [self mt_setLocale:locale];
}

+ (void)setTimeZone:(NSTimeZone *)timeZone
{
    [self mt_setTimeZone:timeZone];
}

+ (void)setFirstDayOfWeek:(NSUInteger)firstDay
{
    [self mt_setFirstDayOfWeek:firstDay];
}

+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system {
    [self mt_setWeekNumberingSystem:system];
}

#pragma mark - CONSTRUCTORS (NO PREFIX)

+ (NSDate *)dateFromISOString:(NSString *)ISOString
{
    return [self mt_dateFromISOString:ISOString];
}

+ (NSDate *)dateFromString:(NSString *)string usingFormat:(NSString *)format
{
    return [self mt_dateFromString:string usingFormat:format];
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    return [self mt_dateFromYear:year month:month day:day];
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    return [self mt_dateFromYear:year month:month day:day hour:hour minute:minute];
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    return [self mt_dateFromYear:year month:month day:day hour:hour minute:minute second:second];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday
{
    return [self mt_dateFromYear:year week:week weekday:weekday];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    return [self mt_dateFromYear:year week:week weekday:weekday hour:hour minute:minute];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    return [self mt_dateFromYear:year week:week weekday:weekday hour:hour minute:minute second:second];
}

- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    return [self mt_dateByAddingYears:years months:months weeks:weeks days:days hours:hours minutes:minutes seconds:seconds];
}

+ (NSDate *)dateFromComponents:(NSDateComponents *)components
{
    return [self mt_dateFromComponents:components];
}

#pragma mark - SYMBOLS (NO PREFIX)

+ (NSArray *)shortWeekdaySymbols
{
    return [self mt_shortWeekdaySymbols];
}

+ (NSArray *)weekdaySymbols
{
    return [self mt_weekdaySymbols];
}

+ (NSArray *)veryShortWeekdaySymbols
{
    return [self mt_veryShortWeekdaySymbols];
}

+ (NSArray *)shortMonthlySymbols
{
    return [self mt_shortMonthlySymbols];
}

+ (NSArray *)monthlySymbols
{
    return [self mt_monthlySymbols];
}

+ (NSArray *)veryShortMonthlySymbols
{
    return [self mt_veryShortMonthlySymbols];
}

#pragma mark - COMPONENTS (NO PREFIX)

- (NSUInteger)year
{
    return [self mt_year];
}

- (NSUInteger)weekOfYear
{
    return [self mt_weekOfYear];
}

- (NSUInteger)weekdayOfWeek
{
    return [self mt_weekdayOfWeek];
}

- (NSUInteger)weekOfMonth
{
    return [self mt_weekOfMonth];
}

- (NSUInteger)monthOfYear
{
    return [self mt_monthOfYear];
}

- (NSUInteger)dayOfMonth
{
    return [self mt_dayOfMonth];
}

- (NSUInteger)hourOfDay
{
    return [self mt_hourOfDay];
}

- (NSUInteger)minuteOfHour
{
    return [self mt_minuteOfHour];
}

- (NSUInteger)secondOfMinute
{
    return [self mt_secondOfMinute];
}

- (NSTimeInterval)secondsIntoDay
{
    return [self mt_secondsIntoDay];
}

- (NSDateComponents *)components
{
    return [self mt_components];
}

#pragma mark - RELATIVES (NO PREFIX)


#pragma mark years

- (NSDate *)startOfPreviousYear
{
    return [self mt_startOfPreviousYear];
}

- (NSDate *)startOfCurrentYear
{
    return [self mt_startOfCurrentYear];
}

- (NSDate *)startOfNextYear
{
    return [self mt_startOfNextYear];
}

- (NSDate *)endOfPreviousYear
{
    return [self mt_endOfPreviousYear];
}

- (NSDate *)endOfCurrentYear
{
    return [self mt_endOfCurrentYear];
}

- (NSDate *)endOfNextYear
{
    return [self mt_endOfNextYear];
}

- (NSDate *)oneYearPrevious
{
    return [self mt_oneYearPrevious];
}

- (NSDate *)oneYearNext
{
    return [self mt_oneYearNext];
}

- (NSDate *)dateYearsBefore:(NSUInteger)years
{
    return [self mt_dateYearsBefore:years];
}

- (NSDate *)dateYearsAfter:(NSUInteger)years
{
    return [self mt_dateYearsAfter:years];
}

- (NSInteger)yearsSinceDate:(NSDate *)date
{
    return [self mt_yearsSinceDate:date];
}

- (NSInteger)yearsUntilDate:(NSDate *)date
{
    return [self mt_yearsUntilDate:date];
}

#pragma mark months

- (NSDate *)startOfPreviousMonth
{
    return [self mt_startOfPreviousMonth];
}

- (NSDate *)startOfCurrentMonth
{
    return [self mt_startOfCurrentMonth];
}

- (NSDate *)startOfNextMonth
{
    return [self mt_startOfNextMonth];
}

- (NSDate *)endOfPreviousMonth
{
    return [self mt_endOfPreviousMonth];
}

- (NSDate *)endOfCurrentMonth
{
    return [self mt_endOfCurrentMonth];
}

- (NSDate *)endOfNextMonth
{
    return [self mt_endOfNextMonth];
}

- (NSDate *)oneMonthPrevious
{
    return [self mt_oneMonthPrevious];
}

- (NSDate *)oneMonthNext
{
    return [self mt_oneMonthNext];
}

- (NSDate *)dateMonthsBefore:(NSUInteger)months
{
    return [self mt_dateMonthsBefore:months];
}

- (NSDate *)dateMonthsAfter:(NSUInteger)months
{
    return [self mt_dateMonthsAfter:months];
}

- (NSInteger)monthsSinceDate:(NSDate *)date
{
    return [self mt_monthsSinceDate:date];
}

- (NSInteger)monthsUntilDate:(NSDate *)date
{
    return [self mt_monthsUntilDate:date];
}

#pragma mark weeks

- (NSDate *)startOfPreviousWeek
{
    return [self mt_startOfPreviousWeek];
}

- (NSDate *)startOfCurrentWeek
{
    return [self mt_startOfCurrentWeek];
}

- (NSDate *)startOfNextWeek
{
    return [self mt_startOfNextWeek];
}

- (NSDate *)endOfPreviousWeek
{
    return [self mt_endOfPreviousWeek];
}

- (NSDate *)endOfCurrentWeek
{
    return [self mt_endOfCurrentWeek];
}

- (NSDate *)endOfNextWeek
{
    return [self mt_endOfNextWeek];
}

- (NSDate *)oneWeekPrevious
{
    return [self mt_oneWeekPrevious];
}

- (NSDate *)oneWeekNext
{
    return [self mt_oneWeekNext];
}

- (NSDate *)dateWeeksBefore:(NSUInteger)weeks
{
    return [self mt_dateWeeksBefore:weeks];
}

- (NSDate *)dateWeeksAfter:(NSUInteger)weeks
{
    return [self mt_dateWeeksAfter:weeks];
}

- (NSInteger)weeksSinceDate:(NSDate *)date
{
    return [self mt_weeksSinceDate:date];
}

- (NSInteger)weeksUntilDate:(NSDate *)date
{
    return [self mt_weeksUntilDate:date];
}

#pragma mark days

- (NSDate *)startOfPreviousDay
{
    return [self mt_startOfPreviousDay];
}

- (NSDate *)startOfCurrentDay
{
    return [self mt_startOfCurrentDay];
}

- (NSDate *)startOfNextDay
{
    return [self mt_startOfNextDay];
}

- (NSDate *)endOfPreviousDay
{
    return [self mt_endOfPreviousDay];
}

- (NSDate *)endOfCurrentDay
{
    return [self mt_endOfCurrentDay];
}

- (NSDate *)endOfNextDay
{
    return [self mt_endOfNextDay];
}

- (NSDate *)oneDayPrevious
{
    return [self mt_oneDayPrevious];
}

- (NSDate *)oneDayNext
{
    return [self mt_oneDayNext];
}

- (NSDate *)dateDaysBefore:(NSUInteger)days
{
    return [self mt_dateDaysBefore:days];
}

- (NSDate *)dateDaysAfter:(NSUInteger)days
{
    return [self mt_dateDaysAfter:days];
}

- (NSInteger)daysSinceDate:(NSDate *)date
{
    return [self mt_daysSinceDate:date];
}

- (NSInteger)daysUntilDate:(NSDate *)date
{
    return [self mt_daysUntilDate:date];
}

#pragma mark hours

- (NSDate *)startOfPreviousHour
{
    return [self mt_startOfPreviousHour];
}

- (NSDate *)startOfCurrentHour
{
    return [self mt_startOfCurrentHour];
}

- (NSDate *)startOfNextHour
{
    return [self mt_startOfNextHour];
}

- (NSDate *)endOfPreviousHour
{
    return [self mt_endOfPreviousHour];
}

- (NSDate *)endOfCurrentHour
{
    return [self mt_endOfCurrentHour];
}

- (NSDate *)endOfNextHour
{
    return [self mt_endOfNextHour];
}

- (NSDate *)oneHourPrevious
{
    return [self mt_oneHourPrevious];
}

- (NSDate *)oneHourNext
{
    return [self mt_oneHourNext];
}

- (NSDate *)dateHoursBefore:(NSUInteger)hours
{
    return [self mt_dateHoursBefore:hours];
}

- (NSDate *)dateHoursAfter:(NSUInteger)hours
{
    return [self mt_dateHoursAfter:hours];
}

- (NSInteger)hoursSinceDate:(NSDate *)date
{
    return [self mt_hoursSinceDate:date];
}

- (NSInteger)hoursUntilDate:(NSDate *)date
{
    return [self mt_hoursUntilDate:date];
}

#pragma mark minutes

- (NSDate *)startOfPreviousMinute
{
    return [self mt_startOfPreviousMinute];
}

- (NSDate *)startOfCurrentMinute
{
    return [self mt_startOfCurrentMinute];
}

- (NSDate *)startOfNextMinute
{
    return [self mt_startOfNextMinute];
}

- (NSDate *)endOfPreviousMinute
{
    return [self mt_endOfPreviousMinute];
}

- (NSDate *)endOfCurrentMinute
{
    return [self mt_endOfCurrentMinute];
}

- (NSDate *)endOfNextMinute
{
    return [self mt_endOfNextMinute];
}

- (NSDate *)oneMinutePrevious
{
    return [self mt_oneMinutePrevious];
}

- (NSDate *)oneMinuteNext
{
    return [self mt_oneMinuteNext];
}

- (NSDate *)dateMinutesBefore:(NSUInteger)minutes
{
    return [self mt_dateMinutesBefore:minutes];
}

- (NSDate *)dateMinutesAfter:(NSUInteger)minutes
{
    return [self mt_dateMinutesAfter:minutes];
}

- (NSInteger)minutesSinceDate:(NSDate *)date
{
    return [self mt_minutesSinceDate:date];
}

- (NSInteger)minutesUntilDate:(NSDate *)date
{
    return [self mt_minutesUntilDate:date];
}

#pragma mark seconds

- (NSDate *)startOfPreviousSecond
{
    return [self mt_startOfPreviousSecond];
}

- (NSDate *)startOfNextSecond
{
    return [self mt_startOfNextSecond];
}

- (NSDate *)oneSecondPrevious
{
    return [self mt_oneSecondPrevious];
}

- (NSDate *)oneSecondNext
{
    return [self mt_oneSecondNext];
}

- (NSDate *)dateSecondsBefore:(NSUInteger)seconds
{
    return [self mt_dateSecondsBefore:seconds];
}

- (NSDate *)dateSecondsAfter:(NSUInteger)seconds
{
    return [self mt_dateSecondsAfter:seconds];
}

- (NSInteger)secondsSinceDate:(NSDate *)date
{
    return [self mt_secondsSinceDate:date];
}

- (NSInteger)secondsUntilDate:(NSDate *)date
{
    return [self mt_secondsUntilDate:date];
}

#pragma mark - COMPARES (NO PREFIX)

- (BOOL)isAfter:(NSDate *)date
{
    return [self mt_isAfter:date];
}

- (BOOL)isBefore:(NSDate *)date
{
    return [self mt_isBefore:date];
}

- (BOOL)isOnOrAfter:(NSDate *)date
{
    return [self mt_isOnOrAfter:date];
}

- (BOOL)isOnOrBefore:(NSDate *)date
{
    return [self mt_isOnOrBefore:date];
}

- (BOOL)isWithinSameMonth:(NSDate *)date
{
    return [self mt_isWithinSameMonth:date];
}

- (BOOL)isWithinSameWeek:(NSDate *)date
{
    return [self mt_isWithinSameWeek:date];
}

- (BOOL)isWithinSameDay:(NSDate *)date
{
    return [self mt_isWithinSameDay:date];
}

- (BOOL)isWithinSameHour:(NSDate *)date
{
    return [self mt_isWithinSameHour:date];
}

- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    return [self mt_isBetweenDate:date1 andDate:date2];
}

#pragma mark - STRINGS (NO PREFIX)

+ (void)setFormatterDateStyle:(NSDateFormatterStyle)style
{
    return [self mt_setFormatterDateStyle:style];
}

+ (void)setFormatterTimeStyle:(NSDateFormatterStyle)style
{
    return [self mt_setFormatterTimeStyle:style];
}

- (NSString *)stringValue
{
    return [self mt_stringValue];
}

- (NSString *)stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
    return [self mt_stringValueWithDateStyle:dateStyle timeStyle:timeStyle];
}

- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format
{
    return [self mt_stringFromDateWithHourAndMinuteFormat:format];
}

- (NSString *)stringFromDateWithShortMonth
{
    return [self mt_stringFromDateWithShortMonth];
}

- (NSString *)stringFromDateWithFullMonth
{
    return [self mt_stringFromDateWithFullMonth];
}

- (NSString *)stringFromDateWithAMPMSymbol
{
    return [self mt_stringFromDateWithAMPMSymbol];
}

- (NSString *)stringFromDateWithShortWeekdayTitle
{
    return [self mt_stringFromDateWithShortWeekdayTitle];
}

- (NSString *)stringFromDateWithFullWeekdayTitle
{
    return [self mt_stringFromDateWithFullWeekdayTitle];
}

- (NSString *)stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized
{
    return [self mt_stringFromDateWithFormat:format localized:localized];
}

- (NSString *)stringFromDateWithISODateTime
{
    return [self mt_stringFromDateWithISODateTime];
}

- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval
{
    return [self mt_stringFromDateWithGreatestComponentsForSecondsPassed:interval];
}

- (NSString *)stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date
{
    return [self mt_stringFromDateWithGreatestComponentsUntilDate:date];
}

#pragma mark - MISC (NO PREFIX)

+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate
{
    return [self mt_datesCollectionFromDate:startDate untilDate:endDate];
}

- (NSArray *)hoursInCurrentDayAsDatesCollection
{
    return [self mt_hoursInCurrentDayAsDatesCollection];
}

- (BOOL)isInAM
{
    return [self mt_isInAM];
}

- (BOOL)isStartOfAnHour
{
    return [self mt_isStartOfAnHour];
}

- (NSUInteger)weekdayStartOfCurrentMonth
{
    return [self mt_weekdayStartOfCurrentMonth];
}

- (NSUInteger)daysInCurrentMonth
{
    return [self mt_daysInCurrentMonth];
}

- (NSUInteger)daysInPreviousMonth
{
    return [self mt_daysInPreviousMonth];
}

- (NSUInteger)daysInNextMonth
{
    return [self mt_daysInNextMonth];
}

- (NSDate *)inTimeZone:(NSTimeZone *)timezone
{
    return [self mt_inTimeZone:timezone];
}

+ (NSInteger)minValueForUnit:(NSCalendarUnit)unit
{
    return [self mt_minValueForUnit:unit];
}

+ (NSInteger)maxValueForUnit:(NSCalendarUnit)unit
{
    return [self mt_maxValueForUnit:unit];
}

#endif

@end




#pragma mark - Common Date Formats

NSString *const MTDatesFormatDefault        = @"EE, MMM dd, yyyy, HH:mm:ss";       // Sat Jun 09 2007 17:46:21
NSString *const MTDatesFormatShortDate      = @"M/d/yy";                        // 6/9/07
NSString *const MTDatesFormatMediumDate     = @"MMM d, yyyy";                   // Jun 9, 2007
NSString *const MTDatesFormatLongDate       = @"MMMM d, yyyy";                  // June 9, 2007
NSString *const MTDatesFormatFullDate       = @"EEEE, MMMM d, yyyy";            // Saturday, June 9, 2007
NSString *const MTDatesFormatShortTime      = @"h:mm a";                        // 5:46 PM
NSString *const MTDatesFormatMediumTime     = @"h:mm:ss a";                     // 5:46:21 PM
NSString *const MTDatesFormatLongTime       = @"h:mm:ss a zzz";                 // 5:46:21 PM EST
NSString *const MTDatesFormatISODate        = @"yyyy-MM-dd";                    // 2007-06-09
NSString *const MTDatesFormatISOTime        = @"HH:mm:ss";                      // 17:46:21
NSString *const MTDatesFormatISODateTime    = @"yyyy-MM-dd HH:mm:ss";           // 2007-06-09 17:46:21
