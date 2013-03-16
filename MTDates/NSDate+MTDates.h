//
//  NSDate+MTDates.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


// Week Numbering System
typedef enum {
    MTDateWeekNumberingSystemUS       = 1,      // First week contains January 1st.
    MTDateWeekNumberingSystemISO      = 4,      // First week contains January 4th.
    //  MTDateWeekNumberingSystemSimple = 8     // First week starts on January 1st, next on Jan 8th, etc.
} MTDateWeekNumberingSystem;

// Hour Format
typedef enum {
    MTDateHourFormat24Hour,                     // 23:00
    MTDateHourFormat12Hour                      // 11:00PM
} MTDateHourFormat;







@interface NSDate (MTDates)


+ (NSDateFormatter *)mt_sharedFormatter;



# pragma mark - GLOBAL CONFIG

+ (void)mt_setCalendarIdentifier:(NSString *)identifier;
+ (void)mt_setLocale:(NSLocale *)locale;
+ (void)mt_setTimeZone:(NSTimeZone *)timeZone;
+ (void)mt_setFirstDayOfWeek:(NSUInteger)firstDay; // Sunday: 1, Saturday: 7
+ (void)mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)system;




#pragma mark - CONSTRUCTORS

+ (NSDate *)mt_dateFromISOString:(NSString *)ISOString;
+ (NSDate *)mt_dateFromString:(NSString *)string usingFormat:(NSString *)format;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)mt_dateFromYear:(NSUInteger)year week:(NSUInteger)week weekday:(NSUInteger)weekday hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
- (NSDate *)mt_dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
+ (NSDate *)mt_dateFromComponents:(NSDateComponents *)components;




#pragma mark - SYMBOLS

+ (NSArray *)mt_shortWeekdaySymbols;
+ (NSArray *)mt_weekdaySymbols;
+ (NSArray *)mt_veryShortWeekdaySymbols;
+ (NSArray *)mt_shortMonthlySymbols;
+ (NSArray *)mt_monthlySymbols;
+ (NSArray *)mt_veryShortMonthlySymbols;




#pragma mark - COMPONENTS

- (NSUInteger)mt_year;
- (NSUInteger)mt_weekOfYear;
- (NSUInteger)mt_weekdayOfWeek;
- (NSUInteger)mt_weekOfMonth;
- (NSUInteger)mt_monthOfYear;
- (NSUInteger)mt_dayOfMonth;
- (NSUInteger)mt_hourOfDay;
- (NSUInteger)mt_minuteOfHour;
- (NSUInteger)mt_secondOfMinute;
- (NSTimeInterval)mt_secondsIntoDay;
- (NSDateComponents *)mt_components;




#pragma mark - RELATIVES


#pragma mark years

- (NSDate *)mt_startOfPreviousYear;
- (NSDate *)mt_startOfCurrentYear;
- (NSDate *)mt_startOfNextYear;

- (NSDate *)mt_endOfPreviousYear;
- (NSDate *)mt_endOfCurrentYear;
- (NSDate *)mt_endOfNextYear;

- (NSDate *)mt_oneYearPrevious;
- (NSDate *)mt_oneYearNext;

- (NSDate *)mt_dateYearsBefore:(NSUInteger)years;
- (NSDate *)mt_dateYearsAfter:(NSUInteger)years;

- (NSInteger)mt_yearsSinceDate:(NSDate *)date;
- (NSInteger)mt_yearsUntilDate:(NSDate *)date;


#pragma mark months

- (NSDate *)mt_startOfPreviousMonth;
- (NSDate *)mt_startOfCurrentMonth;
- (NSDate *)mt_startOfNextMonth;

- (NSDate *)mt_endOfPreviousMonth;
- (NSDate *)mt_endOfCurrentMonth;
- (NSDate *)mt_endOfNextMonth;

- (NSDate *)mt_oneMonthPrevious;
- (NSDate *)mt_oneMonthNext;

- (NSDate *)mt_dateMonthsBefore:(NSUInteger)months;
- (NSDate *)mt_dateMonthsAfter:(NSUInteger)months;

- (NSInteger)mt_monthsSinceDate:(NSDate *)date;
- (NSInteger)mt_monthsUntilDate:(NSDate *)date;


#pragma mark weeks

- (NSDate *)mt_startOfPreviousWeek;
- (NSDate *)mt_startOfCurrentWeek;
- (NSDate *)mt_startOfNextWeek;

- (NSDate *)mt_endOfPreviousWeek;
- (NSDate *)mt_endOfCurrentWeek;
- (NSDate *)mt_endOfNextWeek;

- (NSDate *)mt_oneWeekPrevious;
- (NSDate *)mt_oneWeekNext;

- (NSDate *)mt_dateWeeksBefore:(NSUInteger)weeks;
- (NSDate *)mt_dateWeeksAfter:(NSUInteger)weeks;

- (NSInteger)mt_weeksSinceDate:(NSDate *)date;
- (NSInteger)mt_weeksUntilDate:(NSDate *)date;


#pragma mark days

- (NSDate *)mt_startOfPreviousDay;
- (NSDate *)mt_startOfCurrentDay;
- (NSDate *)mt_startOfNextDay;

- (NSDate *)mt_endOfPreviousDay;
- (NSDate *)mt_endOfCurrentDay;
- (NSDate *)mt_endOfNextDay;

- (NSDate *)mt_oneDayPrevious;
- (NSDate *)mt_oneDayNext;

- (NSDate *)mt_dateDaysBefore:(NSUInteger)days;
- (NSDate *)mt_dateDaysAfter:(NSUInteger)days;

- (NSInteger)mt_daysSinceDate:(NSDate *)date;
- (NSInteger)mt_daysUntilDate:(NSDate *)date;


#pragma mark hours

- (NSDate *)mt_startOfPreviousHour;
- (NSDate *)mt_startOfCurrentHour;
- (NSDate *)mt_startOfNextHour;

- (NSDate *)mt_endOfPreviousHour;
- (NSDate *)mt_endOfCurrentHour;
- (NSDate *)mt_endOfNextHour;

- (NSDate *)mt_oneHourPrevious;
- (NSDate *)mt_oneHourNext;

- (NSDate *)mt_dateHoursBefore:(NSUInteger)hours;
- (NSDate *)mt_dateHoursAfter:(NSUInteger)hours;

- (NSInteger)mt_hoursSinceDate:(NSDate *)date;
- (NSInteger)mt_hoursUntilDate:(NSDate *)date;

#pragma mark minutes

- (NSDate *)mt_startOfPreviousMinute;
- (NSDate *)mt_startOfCurrentMinute;
- (NSDate *)mt_startOfNextMinute;

- (NSDate *)mt_endOfPreviousMinute;
- (NSDate *)mt_endOfCurrentMinute;
- (NSDate *)mt_endOfNextMinute;

- (NSDate *)mt_oneMinutePrevious;
- (NSDate *)mt_oneMinuteNext;

- (NSDate *)mt_dateMinutesBefore:(NSUInteger)minute;
- (NSDate *)mt_dateMinutesAfter:(NSUInteger)minute;

- (NSInteger)mt_minutesSinceDate:(NSDate *)date;
- (NSInteger)mt_minutesUntilDate:(NSDate *)date;

#pragma mark seconds

- (NSDate *)mt_startOfPreviousSecond;
- (NSDate *)mt_startOfNextSecond;

- (NSDate *)mt_oneSecondPrevious;
- (NSDate *)mt_oneSecondNext;

- (NSDate *)mt_dateSecondsBefore:(NSUInteger)seconds;
- (NSDate *)mt_dateSecondsAfter:(NSUInteger)seconds;

- (NSInteger)mt_secondsSinceDate:(NSDate *)date;
- (NSInteger)mt_secondsUntilDate:(NSDate *)date;


#pragma mark - COMPARES

- (BOOL)mt_isAfter:(NSDate *)date;
- (BOOL)mt_isBefore:(NSDate *)date;
- (BOOL)mt_isOnOrAfter:(NSDate *)date;
- (BOOL)mt_isOnOrBefore:(NSDate *)date;
- (BOOL)mt_isWithinSameMonth:(NSDate *)date;
- (BOOL)mt_isWithinSameWeek:(NSDate *)date;
- (BOOL)mt_isWithinSameDay:(NSDate *)date;
- (BOOL)mt_isWithinSameHour:(NSDate *)date;
- (BOOL)mt_isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;




#pragma mark - STRINGS

+ (void)mt_setFormatterDateStyle:(NSDateFormatterStyle)style;
+ (void)mt_setFormatterTimeStyle:(NSDateFormatterStyle)style;

- (NSString *)mt_stringValue;
- (NSString *)mt_stringValueWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)mt_stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format;
- (NSString *)mt_stringFromDateWithShortMonth;
- (NSString *)mt_stringFromDateWithFullMonth;
- (NSString *)mt_stringFromDateWithAMPMSymbol;
- (NSString *)mt_stringFromDateWithShortWeekdayTitle;
- (NSString *)mt_stringFromDateWithFullWeekdayTitle;
- (NSString *)mt_stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized;    // http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
- (NSString *)mt_stringFromDateWithISODateTime;
- (NSString *)mt_stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;
- (NSString *)mt_stringFromDateWithGreatestComponentsUntilDate:(NSDate *)date;




#pragma mark - MISC

+ (NSArray *)mt_datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
- (NSArray *)mt_hoursInCurrentDayAsDatesCollection;
- (BOOL)mt_isInAM;
- (BOOL)mt_isStartOfAnHour;
- (NSUInteger)mt_weekdayStartOfCurrentMonth;
- (NSUInteger)mt_daysInCurrentMonth;
- (NSUInteger)mt_daysInPreviousMonth;
- (NSUInteger)mt_daysInNextMonth;
- (NSDate *)mt_inTimeZone:(NSTimeZone *)timezone;
+ (NSInteger)mt_minValueForUnit:(NSCalendarUnit)unit;
+ (NSInteger)mt_maxValueForUnit:(NSCalendarUnit)unit;


@end




#pragma mark - Common Date Formats
// for use with stringFromDateWithFormat:

extern NSString *const MTDatesFormatDefault;          // Sat Jun 09 2007 17:46:21
extern NSString *const MTDatesFormatShortDate;        // 6/9/07
extern NSString *const MTDatesFormatMediumDate;       // Jun 9, 2007
extern NSString *const MTDatesFormatLongDate;         // June 9, 2007
extern NSString *const MTDatesFormatFullDate;         // Saturday, June 9, 2007
extern NSString *const MTDatesFormatShortTime;        // 5:46 PM
extern NSString *const MTDatesFormatMediumTime;       // 5:46:21 PM
extern NSString *const MTDatesFormatLongTime;         // 5:46:21 PM EST
extern NSString *const MTDatesFormatISODate;          // 2007-06-09
extern NSString *const MTDatesFormatISOTime;          // 17:46:21
extern NSString *const MTDatesFormatISODateTime;      // 2007-06-09T17:46:21
//extern NSString *const MTDatesFormatISOUTCDateTime;   // 2007-06-09T22:46:21Z
