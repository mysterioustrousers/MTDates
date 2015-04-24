//
//  NSDate+MTDates.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "NSDate+MTDates.h"


@implementation NSDate (MTDates)


static NSCalendar                   *__calendar             = nil;
static NSDateComponents             *__components           = nil;
static NSDateFormatter              *__formatter            = nil;

static NSString                     *__calendarType         = nil;
static NSLocale                     *__locale               = nil;
static NSTimeZone                   *__timeZone             = nil;
static NSInteger                    __firstWeekday          = 0;
static MTDateWeekNumberingSystem    __weekNumberingSystem   = 0;

static NSDateFormatterStyle         __dateStyle             = NSDateFormatterShortStyle;
static NSDateFormatterStyle         __timeStyle             = NSDateFormatterShortStyle;


+ (NSDateFormatter *)mt_sharedFormatter
{
	[[NSDate sharedRecursiveLock] lock];
    [self mt_prepareDefaults];

    if (!__formatter) {
        __formatter           = [[NSDateFormatter alloc] init];
        __formatter.calendar  = [self mt_calendar];
        __formatter.locale    = __locale;
        __formatter.timeZone  = __timeZone;
        [__formatter setDateStyle:__dateStyle];
        [__formatter setTimeStyle:__timeStyle];
    }

    NSDateFormatter *formatter = __formatter;
    [[NSDate sharedRecursiveLock] unlock];
    return formatter;
}


#pragma mark - GLOBAL CONFIG

+ (void)mt_setCalendarIdentifier:(NSString *)identifier
{
	[[NSDate sharedRecursiveLock] lock];
    __calendarType = identifier;
    [self mt_reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)mt_setLocale:(NSLocale *)locale
{
	[[NSDate sharedRecursiveLock] lock];
    __locale = locale;
    [self mt_reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)mt_setTimeZone:(NSTimeZone *)timeZone
{
	[[NSDate sharedRecursiveLock] lock];
    __timeZone = timeZone;
    [self mt_reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)mt_setFirstDayOfWeek:(NSInteger)firstDay
{
	[[NSDate sharedRecursiveLock] lock];
    __firstWeekday = firstDay;
    [self mt_reset];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)system
{
	[[NSDate sharedRecursiveLock] lock];
    __weekNumberingSystem = system;
    [self mt_reset];
	[[NSDate sharedRecursiveLock] unlock];
}


#pragma mark - CONSTRUCTORS

+ (NSDate *)mt_dateFromISOString:(NSString *)ISOString
{
	[[NSDate sharedRecursiveLock] lock];
    if (ISOString == nil || (NSNull *)ISOString == [NSNull null]) {
        [[NSDate sharedRecursiveLock] unlock];
        return nil;
    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    NSArray *formatsToTry = @[ @"yyyy-MM-dd'T'HH:mm.ss.SSS'Z'", @"yyyy-MM-dd HH:mm:ss ZZZ", @"yyyy-MM-dd HH:mm:ss Z", @"yyyy-MM-dd HH:mm:ss", @"yyyy-MM-dd'T'HH:mm:ss'Z'", @"yyyy-MM-dd" ];

    NSDate *result = nil;
    for (NSString *format in formatsToTry) {
        [formatter setDateFormat:format];
        result = [formatter dateFromString:ISOString];
        if (result) break;
    }
	[[NSDate sharedRecursiveLock] unlock];
    return result;
}

+ (NSDate *)mt_dateFromString:(NSString *)string usingFormat:(NSString *)format
{
	[[NSDate sharedRecursiveLock] lock];
    if (string == nil || (NSNull *)string == [NSNull null]) {
        [[NSDate sharedRecursiveLock] unlock];
        return nil;
    }
    NSDateFormatter* formatter = [self mt_sharedFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateFromYear:year
                                   month:month
                                     day:day
                                    hour:[NSDate mt_minValueForUnit:NSCalendarUnitHour]
                                  minute:[NSDate mt_minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateFromYear:year
                                   month:month
                                     day:day
                                    hour:hour
                                  minute:minute
                                  second:[NSDate mt_minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate mt_components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *date = [[NSDate mt_calendar] dateFromComponents:comps];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateFromYear:year
                                    week:week
                                 weekday:weekday
                                    hour:[NSDate mt_minValueForUnit:NSCalendarUnitHour]
                                  minute:[NSDate mt_minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateFromYear:year
                                    week:week
                                 weekday:weekday
                                    hour:hour
                                  minute:minute
                                  second:[NSDate mt_minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate mt_components];
    [comps setYear:year];
    [comps setWeekOfYear:week];
    [comps setWeekday:weekday];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *date = [[NSDate mt_calendar] dateFromComponents:comps];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [NSDate mt_components];
    if (years)      [comps setYear:years];
    if (months)     [comps setMonth:months];
    if (weeks)      [comps setWeekOfYear:weeks];
    if (days)       [comps setDay:days];
    if (hours)      [comps setHour:hours];
    if (minutes)    [comps setMinute:minutes];
    if (seconds)    [comps setSecond:seconds];
    NSDate *date = [[NSDate mt_calendar] dateByAddingComponents:comps toDate:self options:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate *)mt_dateFromComponents:(NSDateComponents *)components
{
    if (!components) return nil;
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate mt_calendar] dateFromComponents:components];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_startOfToday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_startOfYesterday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_startOfPreviousDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_startOfTomorrow
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_startOfNextDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_endOfToday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_endOfYesterday
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_endOfPreviousDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSDate*)mt_endOfTomorrow
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[NSDate date] mt_endOfNextDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


#pragma mark - SYMBOLS

+ (NSArray *)mt_shortWeekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] shortWeekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)mt_weekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] weekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)mt_veryShortWeekdaySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] veryShortWeekdaySymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)mt_shortMonthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] shortMonthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)mt_monthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] monthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

+ (NSArray *)mt_veryShortMonthlySymbols
{
	[[NSDate sharedRecursiveLock] lock];
    NSArray *array = [[NSDate mt_sharedFormatter] veryShortMonthSymbols];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}


#pragma mark - COMPONENTS

- (NSInteger)mt_year
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitYear fromDate:self];
    NSInteger year = [components year];
	[[NSDate sharedRecursiveLock] unlock];
    return year;
}

- (NSInteger)mt_weekOfYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitWeekOfYear | NSCalendarUnitYear fromDate:self];
    NSInteger weekOfYear = [comps weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weekOfYear;
}

- (NSInteger)mt_dayOfYear
{
    [[NSDate sharedRecursiveLock] lock];
    NSInteger dayOfYear = [[NSDate mt_calendar] ordinalityOfUnit:NSCalendarUnitDay
                                                           inUnit:NSCalendarUnitYear
                                                          forDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return dayOfYear;
}

- (NSInteger)mt_weekOfMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitWeekOfMonth fromDate:self];
    NSInteger weekOfMonth = [components weekOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return weekOfMonth;
}

- (NSInteger)mt_weekdayOfWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekdayOfWeek = [[NSDate mt_calendar] ordinalityOfUnit:NSCalendarUnitWeekday
                                                               inUnit:NSCalendarUnitWeekOfYear
                                                              forDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return weekdayOfWeek;
}

- (NSInteger)mt_monthOfYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitMonth fromDate:self];
    NSInteger monthOfYear = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return monthOfYear;
}

- (NSInteger)mt_dayOfMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitDay fromDate:self];
    NSInteger dayOfMonth = [components day];
	[[NSDate sharedRecursiveLock] unlock];
    return dayOfMonth;
}

- (NSInteger)mt_hourOfDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitHour fromDate:self];
    NSInteger hourOfDay = [components hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hourOfDay;
}

- (NSInteger)mt_minuteOfHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitMinute fromDate:self];
    NSInteger minuteOfHour = [components minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minuteOfHour;
}

- (NSInteger)mt_secondOfMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitSecond fromDate:self];
    NSInteger secondOfMinute = [components second];
	[[NSDate sharedRecursiveLock] unlock];
    return secondOfMinute;
}

- (NSTimeInterval)mt_secondsIntoDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger date = [self timeIntervalSinceDate:[self mt_startOfCurrentDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDateComponents *)mt_components
{
	[[NSDate sharedRecursiveLock] lock];
    NSCalendarUnit units = (NSCalendarUnitYear |
                            NSCalendarUnitMonth |
                            NSCalendarUnitWeekOfYear |
                            NSCalendarUnitWeekday |
                            NSCalendarUnitDay |
                            NSCalendarUnitHour |
                            NSCalendarUnitMinute |
                            NSCalendarUnitSecond);
    NSDateComponents *dateComponents = [[NSDate mt_calendar] components:units fromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return dateComponents;
}


#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)mt_startOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneYearPrevious] mt_startOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate mt_dateFromYear:[self mt_year]
                                     month:[NSDate mt_minValueForUnit:NSCalendarUnitMonth]
                                       day:[NSDate mt_minValueForUnit:NSCalendarUnitDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneYearNext] mt_startOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousYear] mt_middleOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentYear];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentYear] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextYear] mt_middleOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneYearPrevious] mt_endOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentYear] mt_dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextYear
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneYearNext] mt_endOfCurrentYear];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_oneYearPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:-1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneYearNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateYearsBefore:(NSInteger)years
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:-years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateYearsAfter:(NSInteger)years
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_yearsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitYear fromDate:date toDate:self options:0];
    NSInteger years = [comps year];
	[[NSDate sharedRecursiveLock] unlock];
    return years;
}


- (NSInteger)mt_yearsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitYear fromDate:self toDate:date options:0];
    NSInteger years = [comps year];
	[[NSDate sharedRecursiveLock] unlock];
    return years;
}


#pragma mark months

- (NSDate *)mt_startOfPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMonthPrevious] mt_startOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate mt_dateFromYear:[self mt_year]
                                     month:[self mt_monthOfYear]
                                       day:[NSDate mt_minValueForUnit:NSCalendarUnitDay]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMonthNext] mt_startOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_middleOfPreviousMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousMonth] mt_middleOfCurrentMonth];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentMonth];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentMonth] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextMonth] mt_middleOfCurrentMonth];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMonthPrevious] mt_endOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentMonth] mt_dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMonthNext] mt_endOfCurrentMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_oneMonthPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:-1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneMonthNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateMonthsBefore:(NSInteger)months
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:-months weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateMonthsAfter:(NSInteger)months
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:months weeks:0 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_monthsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitMonth fromDate:date toDate:self options:0];
    NSInteger months = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return months;
}


- (NSInteger)mt_monthsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitMonth fromDate:self toDate:date options:0];
    NSInteger months = [components month];
	[[NSDate sharedRecursiveLock] unlock];
    return months;
}


#pragma mark weeks

- (NSDate *)mt_startOfPreviousWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneWeekPrevious] mt_startOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekday = [self mt_weekdayOfWeek];
    NSDate *date = [self mt_dateDaysAfter:-(weekday - 1)];
    NSDate *startOfCurrentWeek = [NSDate mt_dateFromYear:[date mt_year]
                                                   month:[date mt_monthOfYear]
                                                     day:[date mt_dayOfMonth]
                                                    hour:[NSDate mt_minValueForUnit:NSCalendarUnitHour]
                                                  minute:[NSDate mt_minValueForUnit:NSCalendarUnitMinute]
                                                  second:[NSDate mt_minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return startOfCurrentWeek;
}

- (NSDate *)mt_startOfNextWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneWeekNext] mt_startOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_middleOfPreviousWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousWeek] mt_middleOfCurrentWeek];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentWeek];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentWeek] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextWeek
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextWeek] mt_middleOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneWeekPrevious] mt_endOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentWeek] mt_dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextWeek
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneWeekNext] mt_endOfCurrentWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_oneWeekPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:-1 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneWeekNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateWeeksBefore:(NSInteger)weeks
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:-weeks days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateWeeksAfter:(NSInteger)weeks
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:weeks days:0 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_weeksSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitWeekOfYear fromDate:date toDate:self options:0];
    NSInteger weeks = [components weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weeks;
}

- (NSInteger)mt_weeksUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *components = [[NSDate mt_calendar] components:NSCalendarUnitWeekOfYear fromDate:self toDate:date options:0];
    NSInteger weeks = [components weekOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return weeks;
}


#pragma mark days

- (NSDate *)mt_startOfPreviousDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneDayPrevious] mt_startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate mt_dateFromYear:[self mt_year]
                                     month:[self mt_monthOfYear]
                                       day:[self mt_dayOfMonth]
                                      hour:[NSDate mt_minValueForUnit:NSCalendarUnitHour]
                                    minute:[NSDate mt_minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneDayNext] mt_startOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_middleOfPreviousDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousDay] mt_middleOfCurrentDay];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentDay];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentDay] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextDay
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextDay] mt_middleOfCurrentDay];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneDayPrevious] mt_endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentDay] mt_dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextDay
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneDayNext] mt_endOfCurrentDay];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_oneDayPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:-1 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneDayNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateDaysBefore:(NSInteger)days
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:-days hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateDaysAfter:(NSInteger)days
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:days hours:0 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_daysSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    NSInteger days = [comps day];
	[[NSDate sharedRecursiveLock] unlock];
    return days;
}


- (NSInteger)mt_daysUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    NSInteger days = [comps day];
	[[NSDate sharedRecursiveLock] unlock];
    return days;
}


#pragma mark hours

- (NSDate *)mt_startOfPreviousHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneHourPrevious] mt_startOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate mt_dateFromYear:[self mt_year]
                                     month:[self mt_monthOfYear]
                                       day:[self mt_dayOfMonth]
                                      hour:[self mt_hourOfDay]
                                    minute:[NSDate mt_minValueForUnit:NSCalendarUnitMinute]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneHourNext] mt_startOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_middleOfPreviousHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousHour] mt_middleOfCurrentHour];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentHour];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentHour] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextHour
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextHour] mt_middleOfCurrentHour];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneHourPrevious] mt_endOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentHour] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextHour
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneHourNext] mt_endOfCurrentHour];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneHourPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:-1 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneHourNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateHoursBefore:(NSInteger)hours
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:-hours minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateHoursAfter:(NSInteger)hours
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:hours minutes:0 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_hoursSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitHour fromDate:date toDate:self options:0];
    NSInteger hours = [comps hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hours;
}


- (NSInteger)mt_hoursUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitHour fromDate:self toDate:date options:0];
    NSInteger hours = [comps hour];
	[[NSDate sharedRecursiveLock] unlock];
    return hours;
}

#pragma mark minutes

- (NSDate *)mt_startOfPreviousMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMinutePrevious] mt_startOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfCurrentMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [NSDate mt_dateFromYear:[self mt_year]
                                     month:[self mt_monthOfYear]
                                       day:[self mt_dayOfMonth]
                                      hour:[self mt_hourOfDay]
                                    minute:[self mt_minuteOfHour]
                                    second:[NSDate mt_minValueForUnit:NSCalendarUnitSecond]];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMinuteNext] mt_startOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_middleOfPreviousMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfPreviousMinute] mt_middleOfCurrentMinute];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfCurrentMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *start = [self mt_startOfCurrentMinute];
    NSTimeInterval timeInterval = [[self mt_endOfCurrentMinute] timeIntervalSinceDate:start];
    NSDate *date = [start dateByAddingTimeInterval:timeInterval / 2.0];
    [[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_middleOfNextMinute
{
    [[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfNextMinute] mt_middleOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_endOfPreviousMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMinutePrevious] mt_endOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfCurrentMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_startOfCurrentMinute] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_endOfNextMinute
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [[self mt_oneMinuteNext] mt_endOfCurrentMinute];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneMinutePrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-1 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneMinuteNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:1 seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateMinutesBefore:(NSInteger)minutes
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:-minutes seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateMinutesAfter:(NSInteger)minutes
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:minutes seconds:0];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_minutesSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitMinute fromDate:date toDate:self options:0];
    NSInteger minutes = [comps minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minutes;
}


- (NSInteger)mt_minutesUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitMinute fromDate:self toDate:date options:0];
    NSInteger minutes = [comps minute];
	[[NSDate sharedRecursiveLock] unlock];
    return minutes;
}


#pragma mark seconds

- (NSDate *)mt_startOfPreviousSecond
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingTimeInterval:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_startOfNextSecond
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self dateByAddingTimeInterval:1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneSecondPrevious
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_oneSecondNext
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSDate *)mt_dateSecondsBefore:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-seconds];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

- (NSDate *)mt_dateSecondsAfter:(NSInteger)seconds
{
	[[NSDate sharedRecursiveLock] lock];
    NSDate *date = [self mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:seconds];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}


- (NSInteger)mt_secondsSinceDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitSecond fromDate:date toDate:self options:0];
    NSInteger seconds = [comps second];
	[[NSDate sharedRecursiveLock] unlock];
    return seconds;
}


- (NSInteger)mt_secondsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateComponents *comps = [[NSDate mt_calendar] components:NSCalendarUnitSecond fromDate:self toDate:date options:0];
    NSInteger seconds = [comps second];
	[[NSDate sharedRecursiveLock] unlock];
    return seconds;
}

#pragma mark - COMPARES

- (BOOL)mt_isAfter:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isAfter = [self compare:date] == NSOrderedDescending;
	[[NSDate sharedRecursiveLock] unlock];
    return isAfter;
}

- (BOOL)mt_isBefore:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isBefore = [self compare:date] == NSOrderedAscending;
	[[NSDate sharedRecursiveLock] unlock];
    return isBefore;
}

- (BOOL)mt_isOnOrAfter:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isOnOrAfter = [self compare:date] == NSOrderedDescending || [date compare:self] == NSOrderedSame;
	[[NSDate sharedRecursiveLock] unlock];
    return isOnOrAfter;
}

- (BOOL)mt_isOnOrBefore:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isOnOrBefore = [self compare:date] == NSOrderedAscending || [self compare:date] == NSOrderedSame;
	[[NSDate sharedRecursiveLock] unlock];
    return isOnOrBefore;
}

- (BOOL)mt_isWithinSameYear:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameYear = [self mt_year] == [date mt_year];
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameYear;
}

- (BOOL)mt_isWithinSameMonth:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameMonth = [self mt_year] == [date mt_year] && [self mt_monthOfYear] == [date mt_monthOfYear];
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameMonth;
}

- (BOOL)mt_isWithinSameWeek:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameWeek = ([self mt_isOnOrAfter:[date mt_startOfCurrentWeek]] &&
                             [self mt_isOnOrBefore:[date mt_endOfCurrentWeek]]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameWeek;
}

- (BOOL)mt_isWithinSameDay:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameDay = ([self mt_year] == [date mt_year] &&
                            [self mt_monthOfYear] == [date mt_monthOfYear] &&
                            [self mt_dayOfMonth] == [date mt_dayOfMonth]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameDay;
}

- (BOOL)mt_isWithinSameHour:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isWithinSameHour = ([self mt_year] == [date mt_year] &&
                             [self mt_monthOfYear] == [date mt_monthOfYear] &&
                             [self mt_dayOfMonth] == [date mt_dayOfMonth] &&
                             [self mt_hourOfDay] == [date mt_hourOfDay]);
	[[NSDate sharedRecursiveLock] unlock];
    return isWithinSameHour;
}

- (BOOL)mt_isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isBetweenDates = NO;
    if ([self mt_isOnOrAfter:date1] && [self mt_isOnOrBefore:date2]) {
        isBetweenDates = YES;
    }
    else if ([self mt_isOnOrAfter:date2] && [self mt_isOnOrBefore:date1]) {
        isBetweenDates = YES;
    }
    [[NSDate sharedRecursiveLock] unlock];
    return isBetweenDates;
}


#pragma mark - STRINGS

+ (void)mt_setFormatterDateStyle:(NSDateFormatterStyle)style
{
	[[NSDate sharedRecursiveLock] lock];
    __dateStyle = style;
    [[NSDate mt_sharedFormatter] setDateStyle:style];
	[[NSDate sharedRecursiveLock] unlock];
}

+ (void)mt_setFormatterTimeStyle:(NSDateFormatterStyle)style
{
	[[NSDate sharedRecursiveLock] lock];
    __timeStyle = style;
    [[NSDate mt_sharedFormatter] setTimeStyle:style];
	[[NSDate sharedRecursiveLock] unlock];
}

- (NSString *)mt_stringValue
{
	[[NSDate sharedRecursiveLock] lock];
    NSString *stringValue = [[NSDate mt_sharedFormatter] stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return stringValue;
}

- (NSString *)mt_stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle
{
	[[NSDate sharedRecursiveLock] lock];
    [[NSDate mt_sharedFormatter] setDateStyle:dateStyle];
    [[NSDate mt_sharedFormatter] setTimeStyle:timeStyle];
    NSString *str = [[NSDate mt_sharedFormatter] stringFromDate:self];
    [[NSDate mt_sharedFormatter] setDateStyle:__dateStyle];
    [[NSDate mt_sharedFormatter] setTimeStyle:__timeStyle];
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = nil;
    if (format == MTDateHourFormat24Hour) {
        str = [self mt_stringFromDateWithFormat:@"HH:mm" localized:YES];
    }
    else {
        str = [self mt_stringFromDateWithFormat:@"hh:mma" localized:YES];
    }
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithShortMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self mt_stringFromDateWithFormat:@"MMM" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithFullMonth
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self mt_stringFromDateWithFormat:@"MMMM" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithAMPMSymbol
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self mt_stringFromDateWithFormat:@"a" localized:NO];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithShortWeekdayTitle
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self mt_stringFromDateWithFormat:@"E" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithFullWeekdayTitle
{
    [[NSDate sharedRecursiveLock] lock];
    NSString *str = [self mt_stringFromDateWithFormat:@"EEEE" localized:YES];
    [[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateFormatter *formatter = [NSDate mt_sharedFormatter];
    if (localized) format = [NSDateFormatter dateFormatFromTemplate:format options:0 locale:__locale];
    [formatter setDateFormat:format];
    NSString *str = [formatter stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithISODateTime
{
	[[NSDate sharedRecursiveLock] lock];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* result = [formatter stringFromDate:self];
	[[NSDate sharedRecursiveLock] unlock];
    return result;
}

- (NSString *)mt_stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval
{
	[[NSDate sharedRecursiveLock] lock];

    NSMutableString *s = [NSMutableString string];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)MTDateConstantSecondsInMonth);
    if (months > 0) {
        [s appendFormat:@"%ld months, ", (long)months];
        absInterval -= months * MTDateConstantSecondsInMonth;
    }

    NSInteger days = floor(absInterval / (float)MTDateConstantSecondsInDay);
    if (days > 0) {
        [s appendFormat:@"%ld days, ", (long)days];
        absInterval -= days * MTDateConstantSecondsInDay;
    }

    NSInteger hours = floor(absInterval / (float)MTDateConstantSecondsInHour);
    if (hours > 0) {
        [s appendFormat:@"%ld hours, ", (long)hours];
        absInterval -= hours * MTDateConstantSecondsInHour;
    }

    NSInteger minutes = floor(absInterval / (float)MTDateConstantSecondsInMinute);
    if (minutes > 0) {
        [s appendFormat:@"%ld minutes, ", (long)minutes];
        absInterval -= minutes * MTDateConstantSecondsInMinute;
    }

    NSInteger seconds = absInterval;
    if (seconds > 0) {
        [s appendFormat:@"%ld seconds, ", (long)seconds];
    }

    NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
    NSString *str = (interval < 0 ?
                     [NSString stringWithFormat:@"%@ before", preString] :
                     [NSString stringWithFormat:@"%@ after", preString]);
	[[NSDate sharedRecursiveLock] unlock];
    return str;
}

- (NSString *)mt_stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date
{
	[[NSDate sharedRecursiveLock] lock];
    NSMutableArray *s = [NSMutableArray array];
    NSTimeInterval interval = [date timeIntervalSinceDate:self];
    NSTimeInterval absInterval = interval > 0 ? interval : -interval;

    NSInteger months = floor(absInterval / (float)MTDateConstantSecondsInMonth);
    if (months > 0) {
        NSString *formatString = months == 1 ? @"%ld month" : @"%ld months";
        [s addObject:[NSString stringWithFormat:formatString, (long)months]];
        absInterval -= months * MTDateConstantSecondsInMonth;
    }

    NSInteger days = floor(absInterval / (float)MTDateConstantSecondsInDay);
    if (days > 0) {
        NSString *formatString = days == 1 ? @"%ld day" : @"%ld days";
        [s addObject:[NSString stringWithFormat:formatString, (long)days]];
        absInterval -= days * MTDateConstantSecondsInDay;
    }

    NSInteger hours = floor(absInterval / (float)MTDateConstantSecondsInHour);
    if (hours > 0) {
        NSString *formatString = hours == 1 ? @"%ld hour" : @"%ld hours";
        [s addObject:[NSString stringWithFormat:formatString, (long)hours]];
        absInterval -= hours * MTDateConstantSecondsInHour;
    }

    NSInteger minutes = floor(absInterval / (float)MTDateConstantSecondsInMinute);
    if (minutes > 0) {
        NSString *formatString = minutes == 1 ? @"%ld minute" : @"%ld minutes";
        [s addObject:[NSString stringWithFormat:formatString, (long)minutes]];
    }

    NSString *preString = [s componentsJoinedByString:@", "];
    NSString *string = interval < 0 ? [NSString stringWithFormat:@"%@ Ago", preString] : [NSString stringWithFormat:@"In %@", preString];
	[[NSDate sharedRecursiveLock] unlock];
    return string;
}


#pragma mark - MISC

+ (NSArray *)mt_datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger days = [endDate mt_daysSinceDate:startDate];
    NSMutableArray *datesArray = [NSMutableArray array];

    for (int i = 0; i < days; i++) {
        [datesArray addObject:[startDate mt_dateDaysAfter:i]];
    }

    NSArray *array = [NSArray arrayWithArray:datesArray];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

- (NSArray *)mt_hoursInCurrentDayAsDatesCollection
{
	[[NSDate sharedRecursiveLock] lock];
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 23; i >= 0; i--) {
        [hours addObject:[NSDate mt_dateFromYear:[self mt_year]
                                           month:[self mt_monthOfYear]
                                             day:[self mt_dayOfMonth]
                                            hour:i
                                          minute:0]];
    }
    NSArray *array = [NSArray arrayWithArray:hours];
	[[NSDate sharedRecursiveLock] unlock];
    return array;
}

- (BOOL)mt_isInAM
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isInAM = [self mt_hourOfDay] > 11 ? NO : YES;
	[[NSDate sharedRecursiveLock] unlock];
    return isInAM;
}

- (BOOL)mt_isStartOfAnHour
{
	[[NSDate sharedRecursiveLock] lock];
    BOOL isStartOfAnHour = ([self mt_minuteOfHour] == (NSInteger)[NSDate mt_minValueForUnit:NSCalendarUnitMinute] &&
                            [self mt_secondOfMinute] == (NSInteger)[NSDate mt_minValueForUnit:NSCalendarUnitSecond]);
	[[NSDate sharedRecursiveLock] unlock];
    return isStartOfAnHour;
}

- (NSInteger)mt_weekdayStartOfCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger weekdayStartOfCurrentMonth = [[self mt_startOfCurrentMonth] mt_weekdayOfWeek];
	[[NSDate sharedRecursiveLock] unlock];
    return weekdayStartOfCurrentMonth;
}

- (NSInteger)mt_daysInCurrentMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInCurrentMonth = [[self mt_endOfCurrentMonth] mt_dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInCurrentMonth;
}

- (NSInteger)mt_daysInPreviousMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInPreviousMonth = [[self mt_endOfPreviousMonth] mt_dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInPreviousMonth;
}

- (NSInteger)mt_daysInNextMonth
{
	[[NSDate sharedRecursiveLock] lock];
    NSInteger daysInNextMonth = [[self mt_endOfNextMonth] mt_dayOfMonth];
	[[NSDate sharedRecursiveLock] unlock];
    return daysInNextMonth;
}

- (NSDate *)mt_inTimeZone:(NSTimeZone *)timezone
{
	[[NSDate sharedRecursiveLock] lock];
    NSTimeZone *current             = __timeZone ? __timeZone : [NSTimeZone defaultTimeZone];
    NSTimeInterval currentOffset    = [current secondsFromGMTForDate:self];
    NSTimeInterval toOffset         = [timezone secondsFromGMTForDate:self];
    NSTimeInterval diff             = toOffset - currentOffset;
    NSDate *date = [self dateByAddingTimeInterval:diff];
	[[NSDate sharedRecursiveLock] unlock];
    return date;
}

+ (NSInteger)mt_minValueForUnit:(NSCalendarUnit)unit
{
	[[NSDate sharedRecursiveLock] lock];
    NSRange r = [[self mt_calendar] minimumRangeOfUnit:unit];
    NSInteger minValueForUnit = r.location;
	[[NSDate sharedRecursiveLock] unlock];
    return minValueForUnit;
}

+ (NSInteger)mt_maxValueForUnit:(NSCalendarUnit)unit
{
	[[NSDate sharedRecursiveLock] lock];
    NSRange r = [[self mt_calendar] maximumRangeOfUnit:unit];
    NSInteger maxValueForUnit = r.length - 1;
	[[NSDate sharedRecursiveLock] unlock];
    return maxValueForUnit;
}


#pragma mark - Private

+ (void)mt_prepareDefaults
{
    NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];

    if (!__calendarType) {
        __calendarType = [currentCalendar calendarIdentifier];
    }

    if (__weekNumberingSystem == 0) {
        NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];
        __weekNumberingSystem = [currentCalendar minimumDaysInFirstWeek];
    }

    if (__firstWeekday == 0) {
        NSCalendar *currentCalendar = (NSCalendar *)[NSCalendar currentCalendar];
        __firstWeekday = [currentCalendar firstWeekday];
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

    if (!__calendar) {
        __calendar                            = [[NSCalendar alloc] initWithCalendarIdentifier:__calendarType];
        __calendar.firstWeekday               = __firstWeekday;
        __calendar.minimumDaysInFirstWeek     = (NSInteger)__weekNumberingSystem;
        __calendar.timeZone                   = __timeZone;
    }

    return __calendar;
}

+ (NSDateComponents *)mt_components
{
    [self mt_prepareDefaults];

    if (!__components) {
        __components = [[NSDateComponents alloc] init];
        __components.calendar = [self mt_calendar];
        if (__timeZone) __components.timeZone = __timeZone;
    }

    [__components setEra:NSDateComponentUndefined];
    [__components setYear:NSDateComponentUndefined];
    [__components setMonth:NSDateComponentUndefined];
    [__components setDay:NSDateComponentUndefined];
    [__components setHour:NSDateComponentUndefined];
    [__components setMinute:NSDateComponentUndefined];
    [__components setSecond:NSDateComponentUndefined];
    [__components setWeekOfYear:NSDateComponentUndefined];
    [__components setWeekday:NSDateComponentUndefined];
    [__components setWeekdayOrdinal:NSDateComponentUndefined];
    [__components setQuarter:NSDateComponentUndefined];

    return __components;
}

+ (void)mt_reset
{
    [[NSDate sharedRecursiveLock] lock];
    __calendar      = nil;
    __components    = nil;
    __formatter     = nil;
    [[NSDate sharedRecursiveLock] unlock];
}

+ (NSRecursiveLock *)sharedRecursiveLock
{
    static NSRecursiveLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSRecursiveLock new];
    });
    return lock;
}

@end


#pragma mark - Common Date Formats

NSString *const MTDatesFormatDefault        = @"EE, MMM dd, yyyy, HH:mm:ss";    // Sat Jun 09 2007 17:46:21
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
