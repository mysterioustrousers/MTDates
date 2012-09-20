//
//  NSDate+MTDates.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


// Week Numbering System
typedef enum {
	MTDateWeekNumberingSystemUS		= 1,	// First week contains January 1st.
	MTDateWeekNumberingSystemISO	= 4,	// First week contains January 4th.
//	MTDateWeekNumberingSystemSimple	= 8		// First week starts on January 1st, next on Jan 8th, etc.
} MTDateWeekNumberingSystem;

// Hour Format
typedef enum {
	MTDateHourFormat24Hour,					// 23:00
	MTDateHourFormat12Hour					// 11:00PM
} MTDateHourFormat;







@interface NSDate (MTDates)




# pragma mark - GLOBAL CONFIG

+ (void)setLocale:(NSLocale *)locale;
+ (void)setTimeZone:(NSTimeZone *)timeZone;
+ (void)setFirstDayOfWeek:(NSUInteger)firstDay; // Sunday: 1, Saturday: 7
+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system;




#pragma mark - CONSTRUCTORS

+ (NSDate *)dateFromISOString:(NSString *)ISOString;
+ (NSDate *)dateFromString:(NSString *)string usingFormat:(NSString *)format;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+ (NSDate *)dateFromComponents:(NSDateComponents *)components;




#pragma mark - SYMBOLS

+ (NSArray *)shortWeekdaySymbols;
+ (NSArray *)weekdaySymbols;
+ (NSArray *)veryShortWeekdaySymbols;
+ (NSArray *)shortMonthlySymbols;
+ (NSArray *)monthlySymbols;
+ (NSArray *)veryShortMonthlySymbols;




#pragma mark - COMPONENTS

- (NSUInteger)year;
- (NSUInteger)weekOfYear;
- (NSUInteger)weekDayOfWeek;
- (NSUInteger)monthOfYear;
- (NSUInteger)dayOfMonth;
- (NSUInteger)hourOfDay;
- (NSUInteger)minuteOfHour;
- (NSUInteger)secondOfMinute;
- (NSTimeInterval)secondsIntoDay;
- (NSDateComponents *)components;




#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)startOfPreviousYear;
- (NSDate *)startOfCurrentYear;
- (NSDate *)startOfNextYear;

- (NSDate *)endOfPreviousYear;
- (NSDate *)endOfCurrentYear;
- (NSDate *)endOfNextYear;

- (NSDate *)oneYearPrevious;
- (NSDate *)oneYearNext;

- (NSDate *)dateYearsBefore:(NSUInteger)years;
- (NSDate *)dateYearsAfter:(NSUInteger)years;

- (NSInteger)yearsSinceDate:(NSDate *)date;
- (NSInteger)yearsUntilDate:(NSDate *)date;


#pragma mark months

- (NSDate *)startOfPreviousMonth;
- (NSDate *)startOfCurrentMonth;
- (NSDate *)startOfNextMonth;

- (NSDate *)endOfPreviousMonth;
- (NSDate *)endOfCurrentMonth;
- (NSDate *)endOfNextMonth;

- (NSDate *)oneMonthPrevious;
- (NSDate *)oneMonthNext;

- (NSDate *)dateMonthsBefore:(NSUInteger)months;
- (NSDate *)dateMonthsAfter:(NSUInteger)months;

- (NSInteger)monthsSinceDate:(NSDate *)date;
- (NSInteger)monthsUntilDate:(NSDate *)date;


#pragma mark weeks

- (NSDate *)startOfPreviousWeek;
- (NSDate *)startOfCurrentWeek;
- (NSDate *)startOfNextWeek;

- (NSDate *)endOfPreviousWeek;
- (NSDate *)endOfCurrentWeek;
- (NSDate *)endOfNextWeek;

- (NSDate *)oneWeekPrevious;
- (NSDate *)oneWeekNext;

- (NSDate *)dateWeeksBefore:(NSUInteger)weeks;
- (NSDate *)dateWeeksAfter:(NSUInteger)weeks;

- (NSInteger)weeksSinceDate:(NSDate *)date;
- (NSInteger)weeksUntilDate:(NSDate *)date;


#pragma mark days

- (NSDate *)startOfPreviousDay;
- (NSDate *)startOfCurrentDay;
- (NSDate *)startOfNextDay;

- (NSDate *)endOfPreviousDay;
- (NSDate *)endOfCurrentDay;
- (NSDate *)endOfNextDay;

- (NSDate *)oneDayPrevious;
- (NSDate *)oneDayNext;

- (NSDate *)dateDaysBefore:(NSUInteger)days;
- (NSDate *)dateDaysAfter:(NSUInteger)days;

- (NSInteger)daysSinceDate:(NSDate *)date;
- (NSInteger)daysUntilDate:(NSDate *)date;


#pragma mark hours

- (NSDate *)startOfPreviousHour;
- (NSDate *)startOfCurrentHour;
- (NSDate *)startOfNextHour;

- (NSDate *)endOfPreviousHour;
- (NSDate *)endOfCurrentHour;
- (NSDate *)endOfNextHour;

- (NSDate *)oneHourPrevious;
- (NSDate *)oneHourNext;

- (NSDate *)dateHoursBefore:(NSUInteger)hours;
- (NSDate *)dateHoursAfter:(NSUInteger)hours;

- (NSInteger)hoursSinceDate:(NSDate *)date;
- (NSInteger)hoursUntilDate:(NSDate *)date;



#pragma mark - COMPARES

- (BOOL)isAfter:(NSDate *)date;
- (BOOL)isBefore:(NSDate *)date;
- (BOOL)isOnOrAfter:(NSDate *)date;
- (BOOL)isOnOrBefore:(NSDate *)date;
- (BOOL)isWithinSameMonth:(NSDate *)date;
- (BOOL)isWithinSameWeek:(NSDate *)date;
- (BOOL)isWithinSameDay:(NSDate *)date;
- (BOOL)isWithinSameHour:(NSDate *)date;
- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;




#pragma mark - STRINGS

- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format;
- (NSString *)stringFromDateWithShortMonth;
- (NSString *)stringFromDateWithFullMonth;
- (NSString *)stringFromDateWithAMPMSymbol;
- (NSString *)stringFromDateWithShortWeekdayTitle;
- (NSString *)stringFromDateWithFullWeekdayTitle;
- (NSString *)stringFromDateWithFormat:(NSString *)format;		// http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
- (NSString *)stringFromDateWithISODateTime;
- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;




#pragma mark - MISC

+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
- (NSArray *)hoursInCurrentDayAsDatesCollection;
- (BOOL)isInAM;
- (BOOL)isStartOfAnHour;
- (NSUInteger)weekdayStartOfCurrentMonth;
- (NSUInteger)daysInCurrentMonth;
- (NSUInteger)daysInPreviousMonth;
- (NSUInteger)daysInNextMonth;
- (NSDate *)inTimeZone:(NSTimeZone *)timezone;


@end




#pragma mark - Common Date Formats
// for use with stringFromDateWithFormat:

extern NSString *const MTDatesFormatDefault;			// Sat Jun 09 2007 17:46:21
extern NSString *const MTDatesFormatShortDate;			// 6/9/07
extern NSString *const MTDatesFormatMediumDate;			// Jun 9, 2007
extern NSString *const MTDatesFormatLongDate;			// June 9, 2007
extern NSString *const MTDatesFormatFullDate;			// Saturday, June 9, 2007
extern NSString *const MTDatesFormatShortTime;			// 5:46 PM
extern NSString *const MTDatesFormatMediumTime;			// 5:46:21 PM
extern NSString *const MTDatesFormatLongTime;			// 5:46:21 PM EST
extern NSString *const MTDatesFormatISODate;			// 2007-06-09
extern NSString *const MTDatesFormatISOTime;			// 17:46:21
extern NSString *const MTDatesFormatISODateTime;		// 2007-06-09T17:46:21
//extern NSString *const MTDatesFormatISOUTCDateTime;		// 2007-06-09T22:46:21Z
