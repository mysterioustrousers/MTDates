//
//  NSDate+Utilities.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (MTDates)




# pragma mark - GLOBAL CONFIG

+ (void)setLocale:(NSLocale *)locale;
+ (void)setTimeZone:(NSTimeZone *)timeZone;



#pragma mark - CONSTRUCTORS

+ (NSDate *)dateFromISOString:(NSString *)ISOString;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)dateFromYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute;
+ (NSDate *)dateFromYear:(NSUInteger)year week:(NSUInteger)week weekDay:(NSUInteger)weekDay hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
- (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months weeks:(NSInteger)weeks days:(NSInteger)days hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;




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
- (NSUInteger)hourOfDayNonMilitary;
- (NSUInteger)minuteOfHour;
- (NSUInteger)secondOfMinute;
- (NSTimeInterval)secondsIntoDay;




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




#pragma mark - COMPARES

- (BOOL)isAfter:(NSDate *)date;
- (BOOL)isBefore:(NSDate *)date;
- (BOOL)isOnOrAfter:(NSDate *)date;
- (BOOL)isOnOrBefore:(NSDate *)date;
- (BOOL)isWithinSameMonth:(NSDate *)date;
- (BOOL)isWithinSameWeek:(NSDate *)date;
- (BOOL)isWithinSameDay:(NSDate *)date;
- (BOOL)isWithinSameHour:(NSDate *)date;




#pragma mark - STRINGS

- (NSString *)stringFromDatesShortMonth;
- (NSString *)stringFromDatesFullMonth;
- (NSString *)stringFromDateWithFormat:(NSString *)format;		// http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
- (NSString *)stringFromDateWithISODateTime;
- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;




#pragma mark - MISC

+ (NSUInteger)convertHour:(NSUInteger)hour toMilitaryFromAM:(BOOL)isAM;
+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
- (NSArray *)hoursInCurrentDayAsDatesCollection;
- (BOOL)isInAM;
- (BOOL)isStartOfAnHour;
- (NSUInteger)weekdayStartOfCurrentMonth;
- (NSUInteger)daysInCurrentMonth;
- (NSUInteger)daysInPreviousMonth;
- (NSUInteger)daysInNextMonth;


@end
