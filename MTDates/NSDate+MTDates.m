//
//  NSDate+MTDates.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "NSDate+MTDates.h"


#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)
#define SECONDS_IN_WEEK (DAYS_IN_WEEK * SECONDS_IN_DAY)
#define SECONDS_IN_MONTH (30 * SECONDS_IN_DAY)








@implementation NSDate (MTDates)

// These are NOT thread safe, so we must use a seperate one on each thread
static NSMutableDictionary *_calendars	= nil;
static NSMutableDictionary *_components = nil;
static NSMutableDictionary *_formatters = nil;

static NSLocale						*_locale				= nil;
static NSTimeZone					*_timeZone				= nil;
static NSUInteger					_firstWeekday			= 1;
static MTDateWeekNumberingSystem	_weekNumberingSystem	= 1;




#pragma mark - STATIC 

+ (NSCalendar *)calendar
{
	if (!_calendars) _calendars = [NSMutableDictionary dictionary];

	dispatch_queue_t queue = dispatch_get_current_queue();
	NSString *queueLabel = [NSString stringWithUTF8String:dispatch_queue_get_label(queue)];
	NSCalendar *calendar = [_calendars objectForKey:queueLabel];

	if (!calendar) {
		calendar = [[NSCalendar currentCalendar] copy];
		calendar.firstWeekday = _firstWeekday;
		calendar.minimumDaysInFirstWeek = (NSUInteger)_weekNumberingSystem;
		[_calendars setObject:calendar forKey:queueLabel];
	}
    
    return calendar;
}

+ (NSDateComponents *)components
{
	if (!_components) _components = [NSMutableDictionary dictionary];
	
	dispatch_queue_t queue = dispatch_get_current_queue();
	NSString *queueLabel = [NSString stringWithUTF8String:dispatch_queue_get_label(queue)];
	NSDateComponents *component = [_components objectForKey:queueLabel];

	if (!component) {
		component = [[NSDateComponents alloc] init];
		component.calendar = [self calendar];
		if (_timeZone) component.timeZone = _timeZone;
		[_components setObject:component forKey:queueLabel];
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

+ (NSDateFormatter *)formatter
{
	if (!_formatters) _formatters = [NSMutableDictionary dictionary];
	
	dispatch_queue_t queue = dispatch_get_current_queue();
	NSString *queueLabel = [NSString stringWithUTF8String:dispatch_queue_get_label(queue)];
	NSDateFormatter *formatter = [_formatters objectForKey:queueLabel];

	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		formatter.calendar = [self calendar];
		if (_locale) formatter.locale = _locale;
		if (_timeZone) formatter.timeZone = _timeZone;
		[_formatters setObject:formatter forKey:queueLabel];
	}

    return formatter;
}

+ (void)reset
{
	[_calendars removeAllObjects];
	[_components removeAllObjects];
	[_formatters removeAllObjects];
}

+ (void)setLocale:(NSLocale *)locale
{
	_locale = locale;
	[self reset];
}

+ (void)setTimeZone:(NSTimeZone *)timeZone
{
	_timeZone = timeZone;
	[self reset];
}

+ (void)setFirstDayOfWeek:(NSUInteger)firstDay
{
	_firstWeekday = firstDay;
	[self reset];
}

+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system
{
	_weekNumberingSystem = system;
	[self reset];
}




#pragma mark - CONSTRUCTORS

+ (NSDate *)dateFromISOString:(NSString *)ISOString
{
	if (ISOString == nil || (NSNull *)ISOString == [NSNull null]) return nil;
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter dateFromString:ISOString];
}

+ (NSDate *)dateFromString:(NSString *)string usingFormat:(NSString *)format
{
	if (string == nil || (NSNull *)string == [NSNull null]) return nil;
	NSDateFormatter* formatter = [self formatter];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    return [[NSDate calendar] dateFromComponents:comps];
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:0];
    return [[NSDate calendar] dateFromComponents:comps];//@leaks
}

+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    return [[NSDate calendar] dateFromComponents:comps];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setWeek:week];
    [comps setWeekday:weekDay];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    return [[NSDate calendar] dateFromComponents:comps];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setWeek:week];
    [comps setWeekday:weekDay];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:0];
    return [[NSDate calendar] dateFromComponents:comps];
}

+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *comps = [NSDate components];
    [comps setYear:year];
    [comps setWeek:week];
    [comps setWeekday:weekDay];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    return [[NSDate calendar] dateFromComponents:comps];
}

- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    NSDateComponents *comps = [NSDate components];
    if (years)		[comps setYear:years];
    if (months)		[comps setMonth:months];
    if (weeks)		[comps setWeek:weeks];
    if (days)		[comps setDay:days];
    if (hours)		[comps setHour:hours];
    if (minutes)	[comps setMinute:minutes];
    if (seconds)	[comps setSecond:seconds];
    return [[NSDate calendar] dateByAddingComponents:comps toDate:self options:0];
}





#pragma mark - SYMBOLS

+ (NSArray *)shortWeekdaySymbols
{
    return [[NSDate formatter] shortWeekdaySymbols];
}

+ (NSArray *)weekdaySymbols
{
    return [[NSDate formatter] weekdaySymbols];
}

+ (NSArray *)veryShortWeekdaySymbols
{
    return [[NSDate formatter] veryShortWeekdaySymbols];
}

+ (NSArray *)shortMonthlySymbols
{
    return [[NSDate formatter] shortMonthSymbols];
}

+ (NSArray *)monthlySymbols
{
    return [[NSDate formatter] monthSymbols];
}

+ (NSArray *)veryShortMonthlySymbols
{
    return [[NSDate formatter] veryShortMonthSymbols];
}




#pragma mark - COMPONENTS

- (NSUInteger)year
{
    NSDateComponents *components = [[NSDate calendar] components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

- (NSUInteger)weekOfYear
{
    NSDateComponents *comps = [[NSDate calendar] components:NSWeekOfYearCalendarUnit | NSYearCalendarUnit fromDate:self];
    return [comps weekOfYear];
}

- (NSUInteger)weekDayOfWeek
{
    return [[NSDate calendar] ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)monthOfYear
{
    NSDateComponents *components = [[NSDate calendar] components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSUInteger)dayOfMonth
{
    NSDateComponents *components = [[NSDate calendar] components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSUInteger)hourOfDay
{
    NSDateComponents *components = [[NSDate calendar] components:NSHourCalendarUnit fromDate:self];
	return [components hour];
}

- (NSUInteger)minuteOfHour
{
    NSDateComponents *components = [[NSDate calendar] components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}

- (NSUInteger)secondOfMinute
{
    NSDateComponents *components = [[NSDate calendar] components:NSSecondCalendarUnit fromDate:self];
    return [components second];
}

- (NSTimeInterval)secondsIntoDay
{
    return [self timeIntervalSinceDate:[self startOfCurrentDay]];
}




#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)startOfPreviousYear
{
    return [[self startOfCurrentYear] oneYearPrevious];
}

- (NSDate *)startOfCurrentYear
{
    return [NSDate dateFromYear:[self year] month:1 day:1];
}

- (NSDate *)startOfNextYear
{
    return [[self startOfCurrentYear] oneYearNext];
}


- (NSDate *)endOfPreviousYear
{
    return [[self endOfCurrentYear] oneYearPrevious];
}

- (NSDate *)endOfCurrentYear
{
    return [[self startOfCurrentYear] dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)endOfNextYear
{
    return [[self endOfCurrentYear] oneYearNext];
}


- (NSDate *)oneYearPrevious
{
    return [self dateByAddingYears:-1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)oneYearNext
{    
    return [self dateByAddingYears:1 months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSDate *)dateYearsBefore:(NSUInteger)years
{
    return [self dateByAddingYears:-years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)dateYearsAfter:(NSUInteger)years
{
    return [self dateByAddingYears:years months:0 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)yearsSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate calendar] components:NSYearCalendarUnit fromDate:date toDate:self options:0];
    NSInteger years = [comps year];
    return years;
}


#pragma mark months

- (NSDate *)startOfPreviousMonth
{
    return [[self startOfCurrentMonth] oneMonthPrevious];
}

- (NSDate *)startOfCurrentMonth
{
    return [NSDate dateFromYear:[self year] month:[self monthOfYear] day:1];
}

- (NSDate *)startOfNextMonth
{
    return [[self startOfCurrentMonth] oneMonthNext];
}


- (NSDate *)endOfPreviousMonth
{
    return [[self endOfCurrentMonth] oneMonthPrevious];
}

- (NSDate *)endOfCurrentMonth
{
    return [[self startOfCurrentMonth] dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)endOfNextMonth
{
    return [[self endOfCurrentMonth] oneMonthNext];
}


- (NSDate *)oneMonthPrevious
{
    return [self dateByAddingYears:0 months:-1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)oneMonthNext
{
    return [self dateByAddingYears:0 months:1 weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSDate *)dateMonthsBefore:(NSUInteger)months
{
    return [self dateByAddingYears:0 months:-months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)dateMonthsAfter:(NSUInteger)months
{
    return [self dateByAddingYears:0 months:months weeks:0 days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)monthsSinceDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate calendar] components:NSMonthCalendarUnit fromDate:date toDate:self options:0];
    NSInteger months = [components month];
    return months;
}


#pragma mark weeks

- (NSDate *)startOfPreviousWeek
{
    return [[self startOfCurrentWeek] oneWeekPrevious];
}

- (NSDate *)startOfCurrentWeek
{
    NSInteger weekday = [self weekDayOfWeek];
    NSDate *date = [self dateDaysAfter:-(weekday - 1)];
    return [NSDate dateFromYear:[date year] month:[date monthOfYear] day:[date dayOfMonth] hour:0 minute:0 second:0];
}

- (NSDate *)startOfNextWeek
{
    return [[self startOfCurrentWeek] oneWeekNext];
}


- (NSDate *)endOfPreviousWeek
{
    return [[self endOfCurrentWeek] oneWeekPrevious];
}

- (NSDate *)endOfCurrentWeek
{
    return [[self startOfCurrentWeek] dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)endOfNextWeek
{
    return [[self endOfCurrentWeek] oneWeekNext];
}


- (NSDate *)oneWeekPrevious
{
    return [self dateByAddingYears:0 months:0 weeks:-1 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)oneWeekNext
{
    return [self dateByAddingYears:0 months:0 weeks:1 days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)dateWeeksBefore:(NSUInteger)weeks
{
    return [self dateByAddingYears:0 months:0 weeks:-weeks days:0 hours:0 minutes:0 seconds:0];
}

- (NSDate *)dateWeeksAfter:(NSUInteger)weeks
{
    return [self dateByAddingYears:0 months:0 weeks:weeks days:0 hours:0 minutes:0 seconds:0];
}


- (NSInteger)weeksSinceDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate calendar] components:NSWeekCalendarUnit fromDate:date toDate:self options:0];
    NSInteger weeks = [components week];
    return weeks;
}


#pragma mark days

- (NSDate *)startOfPreviousDay
{
    return [[self startOfCurrentDay] oneDayPrevious];
}

- (NSDate *)startOfCurrentDay
{
    return [NSDate dateFromYear:[self year] month:[self monthOfYear] day:[self dayOfMonth] hour:0 minute:0];
}

- (NSDate *)startOfNextDay
{
    return [[self startOfCurrentDay] oneDayNext];
}


- (NSDate *)endOfPreviousDay
{
    return [[self endOfCurrentDay] oneDayPrevious];
}

- (NSDate *)endOfCurrentDay
{
    return [[self startOfCurrentDay] dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:-1];
}

- (NSDate *)endOfNextDay
{
    return [[self endOfCurrentDay] oneDayNext];
}


- (NSDate *)oneDayPrevious
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:-1 hours:0 minutes:0 seconds:0];
}

- (NSDate *)oneDayNext
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:1 hours:0 minutes:0 seconds:0];
}


- (NSDate *)dateDaysBefore:(NSUInteger)days
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:-days hours:0 minutes:0 seconds:0];
}

- (NSDate *)dateDaysAfter:(NSUInteger)days
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:days hours:0 minutes:0 seconds:0];
}


- (NSInteger)daysSinceDate:(NSDate *)date
{    
    NSDateComponents *comps = [[NSDate calendar] components:NSDayCalendarUnit fromDate:date toDate:self options:0];
    NSInteger days = [comps day];
    return days;
}


#pragma mark hours

- (NSDate *)startOfPreviousHour
{
    return [[self startOfCurrentHour] oneHourPrevious];
}

- (NSDate *)startOfCurrentHour
{
    return [NSDate dateFromYear:[self year] month:[self monthOfYear] day:[self dayOfMonth] hour:[self hourOfDay] minute:0];
}

- (NSDate *)startOfNextHour
{
    return [[self startOfCurrentHour] oneHourNext];
}


- (NSDate *)endOfPreviousHour
{
    return [[self endOfCurrentHour] oneHourPrevious];
}

- (NSDate *)endOfCurrentHour
{
    return [[self startOfCurrentHour] dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:-1];
}

- (NSDate *)endOfNextHour
{
    return [[self endOfCurrentHour] oneHourNext];
}

- (NSDate *)oneHourPrevious
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:-1 minutes:0 seconds:0];
}

- (NSDate *)oneHourNext
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:1 minutes:0 seconds:0];
}


- (NSDate *)dateHoursBefore:(NSUInteger)hours
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:-hours minutes:0 seconds:0];
}

- (NSDate *)dateHoursAfter:(NSUInteger)hours
{
    return [self dateByAddingYears:0 months:0 weeks:0 days:0 hours:hours minutes:0 seconds:0];
}


- (NSInteger)hoursSinceDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate calendar] components:NSHourCalendarUnit fromDate:date toDate:self options:0];
    NSInteger hours = [comps hour];
    return hours;
}






#pragma mark - COMPARES

- (BOOL)isAfter:(NSDate *)date
{
    return [self timeIntervalSinceDate:date] > 0 ? YES : NO;
}

- (BOOL)isBefore:(NSDate *)date
{
    return [date timeIntervalSinceDate:self] > 0 ? YES : NO;
}

- (BOOL)isOnOrAfter:(NSDate *)date
{
    return [self timeIntervalSinceDate:date] >= 0 ? YES : NO;
}

- (BOOL)isOnOrBefore:(NSDate *)date
{
    return [date timeIntervalSinceDate:self] >= 0 ? YES : NO;
}

- (BOOL)isWithinSameYear:(NSDate *)date
{
    if ([self year] == [date year]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWithinSameMonth:(NSDate *)date
{
    if ([self year] == [date year] && [self monthOfYear] == [date monthOfYear]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWithinSameWeek:(NSDate *)date
{
    if ([self isOnOrAfter:[date startOfCurrentWeek]] && [self isOnOrBefore:[date endOfCurrentWeek]]) {
        return YES;
    }
    return NO;    
}

- (BOOL)isWithinSameDay:(NSDate *)date
{
    if ([self year] == [date year] && [self monthOfYear] == [date monthOfYear] && [self dayOfMonth] == [date dayOfMonth]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWithinSameHour:(NSDate *)date
{
    if ([self year] == [date year] && [self monthOfYear] == [date monthOfYear] && [self dayOfMonth] == [date dayOfMonth] && [self hourOfDay] == [date hourOfDay]) {
        return YES;
    }
    return NO;
}

- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 {
	if ([self isOnOrAfter:date1] && [self isOnOrBefore:date2])
		return YES;
	else if ([self isOnOrAfter:date2] && [self isOnOrBefore:date1])
		return YES;
	else
		return NO;
}




#pragma mark - STRINGS

- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format {
	if (format == MTDateHourFormat24Hour) {
		return [self stringFromDateWithFormat:@"HH:mm"];
	}
	else {
		return [self stringFromDateWithFormat:@"hh:mma"];
	}
}

- (NSString *)stringFromDateWithShortMonth {
	return [self stringFromDateWithFormat:@"MMM"];
}

- (NSString *)stringFromDateWithFullMonth {
	return [self stringFromDateWithFormat:@"MMMM"];
}

- (NSString *)stringFromDateWithAMPMSymbol {
	return [self stringFromDateWithFormat:@"a"];
}

- (NSString *)stringFromDateWithShortWeekdayTitle {
	return [self stringFromDateWithFormat:@"E"];
}

- (NSString *)stringFromDateWithFullWeekdayTitle {
	return [self stringFromDateWithFormat:@"EEEE"];
}

- (NSString *)stringFromDateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDate formatter];
	[formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)stringFromDateWithISODateTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* result = [formatter stringFromDate:self];
    return result;
}

- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval
{
	
	NSMutableString *s = [NSMutableString string];
	NSTimeInterval absInterval = interval > 0 ? interval : -interval;

	NSInteger months = floor(absInterval / (float)SECONDS_IN_MONTH);
	if (months > 0) {
		[s appendFormat:@"%dl months, ", months];
		absInterval -= months * SECONDS_IN_MONTH;
	}
	
	NSInteger days = floor(absInterval / (float)SECONDS_IN_DAY);
	if (days > 0) {
		[s appendFormat:@"%dl days, ", days];
		absInterval -= days * SECONDS_IN_DAY;
	}
	
	NSInteger hours = floor(absInterval / (float)SECONDS_IN_HOUR);
	if (hours > 0) {
		[s appendFormat:@"%dl hours, ", hours];
		absInterval -= hours * SECONDS_IN_HOUR;
	}

	NSInteger minutes = floor(absInterval / (float)SECONDS_IN_MINUTE);
	if (minutes > 0) {
		[s appendFormat:@"%dl minutes, ", minutes];
		absInterval -= minutes * SECONDS_IN_MINUTE;
	}
	
	NSInteger seconds = absInterval;
	if (seconds > 0) {
		[s appendFormat:@"%dl seconds, ", seconds];
	}
	
	NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
	return interval < 0 ? [NSString stringWithFormat:@"%@ before", preString] : [NSString stringWithFormat:@"%@ after", preString];
}




#pragma mark - MISC

+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate
{
    NSInteger days = [endDate daysSinceDate:startDate];
    NSMutableArray *datesArray = [NSMutableArray array];

    for (int i = 0; i < days; i++) {
        [datesArray addObject:[startDate dateDaysAfter:i]];
    }

    return [NSArray arrayWithArray:datesArray];
}

- (NSArray *)hoursInCurrentDayAsDatesCollection
{
    NSMutableArray *hours = [NSMutableArray array];
    for (int i = 23; i >= 0; i--) {
        [hours addObject:[NSDate dateFromYear:[self year]
                                        month:[self monthOfYear]
                                          day:[self dayOfMonth]
                                         hour:i
                                       minute:0]];
    }
    return [NSArray arrayWithArray:hours];
}

- (BOOL)isInAM
{
    return [self hourOfDay] > 11 ? NO : YES;
}

- (BOOL)isStartOfAnHour
{
    return [self minuteOfHour] == 0 && [self secondOfMinute] == 0;
}

- (NSUInteger)weekdayStartOfCurrentMonth
{
    return [[self startOfCurrentMonth] weekDayOfWeek];
}

- (NSUInteger)daysInCurrentMonth
{
    return [[self endOfCurrentMonth] dayOfMonth];
}

- (NSUInteger)daysInPreviousMonth
{
    return [[self endOfPreviousMonth] dayOfMonth];
}

- (NSUInteger)daysInNextMonth
{
    return [[self endOfNextMonth] dayOfMonth];
}




@end




#pragma mark - Common Date Formats

NSString *const MTDatesFormatDefault		= @"EE MMM dd yyyy HH:mm:ss";		// Sat Jun 09 2007 17:46:21
NSString *const MTDatesFormatShortDate		= @"M/d/yy";						// 6/9/07
NSString *const MTDatesFormatMediumDate		= @"MMM d, yyyy";					// Jun 9, 2007
NSString *const MTDatesFormatLongDate		= @"MMMM d, yyyy";					// June 9, 2007
NSString *const MTDatesFormatFullDate		= @"EEEE, MMMM d, yyyy";			// Saturday, June 9, 2007
NSString *const MTDatesFormatShortTime		= @"h:mm a";						// 5:46 PM
NSString *const MTDatesFormatMediumTime		= @"h:mm:ss a";						// 5:46:21 PM
NSString *const MTDatesFormatLongTime		= @"h:mm:ss a zzz";					// 5:46:21 PM EST
NSString *const MTDatesFormatISODate		= @"yyyy-MM-dd";					// 2007-06-09
NSString *const MTDatesFormatISOTime		= @"HH:mm:ss";						// 17:46:21
NSString *const MTDatesFormatISODateTime	= @"yyyy-MM-dd'T'HH:mm:ss";			// 2007-06-09T17:46:21
//NSString *const MTDatesFormatISOUTCDateTime	= @"yyyy-MM-dd'T'HH:mm:ss'Z'";		// 2007-06-09T22:46:21Z
