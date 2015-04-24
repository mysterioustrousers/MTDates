MTDates
=======
[![Build Status](https://travis-ci.org/mysterioustrousers/MTDates.png)](https://travis-ci.org/mysterioustrousers/MTDates)
[![Version](http://cocoapod-badges.herokuapp.com/v/MTDates/badge.png)](http://cocoadocs.org/docsets/MTDates)
[![Platform](http://cocoapod-badges.herokuapp.com/p/MTDates/badge.png)](http://cocoadocs.org/docsets/MTDates)

MTDates is a category on NSDate that makes common date calculations super easy.

### Installation

In your Podfile, add this line:

```ruby
pod "MTDates"
```

pod? => https://github.com/CocoaPods/CocoaPods/
NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.

### Example Usage

```objective-c
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
formatter.dateFormat = @"MM/dd/yyyy hh:mma";
NSDate *date = [formatter dateFromString:@"07/11/1986 11:29am"];

[date mt_year];                                                     // => 1986

[date mt_weekdayOfWeek];                                            // => 6

[date mt_minuteOfHour];                                             // => 29

[[date mt_startOfPreviousYear] mt_year];                            // => 1985

[[date mt_startOfPreviousYear] mt_stringFromDateWithISODateTime];   // => @"1985-01-01T00:00:00Z"

[[date mt_startOfPreviousMonth] mt_stringFromDatesFullMonth];       // => @"June"
```

### Creating Dates

```objective-c
[NSDate mt_dateFromYear:1986 week:28 weekday:6 hour:11 minute:29 second:0];
```

### Dates From Other Dates

```objective-c
[date mt_dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0];

[date mt_dateYearsAfter:8];

[date mt_oneYearNext];

[date mt_dateMonthsBefore:4];
```

### Comparing Dates

```objective-c
[date mt_isAfter:date2];

[date2 mt_isBefore:date];

[date3 mt_isOnOrBefore:date];

[date2 mt_isWithinSameWeek:date];

[date4 mt_isWithinSameDay:date];
```

### Other Coolness

```objective-c
[date mt_weekdayStartOfCurrentMonth];
[date mt_daysInCurrentMonth];
[date mt_daysInPreviousMonth];
[date mt_daysInNextMonth];
```

### International

```objective-c
[NSDate mt_setFirstDayOfWeek:1];
[NSDate mt_setFirstDayOfWeek:4];

[NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
[NSDate mt_setWeekNumberingSystem:MTDateWeekNumberingSystemUS];
```

### All methods

```objective-c
+ (void)mt_setLocale:(NSLocale *)locale;
+ (void)mt_setTimeZone:(NSTimeZone *)timeZone;
+ (void)mt_setFirstDayOfWeek:(NSUInteger)firstDay; // Sunday: 1, Saturday: 7
+ (void)mt_setWeekNumberingSystem:(MTDateWeekNumberingSystem)system;

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

+ (NSArray *)mt_shortWeekdaySymbols;
+ (NSArray *)mt_weekdaySymbols;
+ (NSArray *)mt_veryShortWeekdaySymbols;
+ (NSArray *)mt_shortMonthlySymbols;
+ (NSArray *)mt_monthlySymbols;
+ (NSArray *)mt_veryShortMonthlySymbols;

- (NSUInteger)mt_year;
- (NSUInteger)mt_weekOfYear;
- (NSUInteger)mt_weekdayOfWeek;
- (NSUInteger)mt_monthOfYear;
- (NSUInteger)mt_dayOfMonth;
- (NSUInteger)mt_hourOfDay;
- (NSUInteger)mt_minuteOfHour;
- (NSUInteger)mt_secondOfMinute;
- (NSTimeInterval)mt_secondsIntoDay;
- (NSDateComponents *)mt_components;

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

- (BOOL)mt_isAfter:(NSDate *)date;
- (BOOL)mt_isBefore:(NSDate *)date;
- (BOOL)mt_isOnOrAfter:(NSDate *)date;
- (BOOL)mt_isOnOrBefore:(NSDate *)date;
- (BOOL)mt_isWithinSameYear:(NSDate *)date;
- (BOOL)mt_isWithinSameMonth:(NSDate *)date;
- (BOOL)mt_isWithinSameWeek:(NSDate *)date;
- (BOOL)mt_isWithinSameDay:(NSDate *)date;
- (BOOL)mt_isWithinSameHour:(NSDate *)date;
- (BOOL)mt_isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;

- (NSString *)mt_stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format;
- (NSString *)mt_stringFromDateWithShortMonth;
- (NSString *)mt_stringFromDateWithFullMonth;
- (NSString *)mt_stringFromDateWithAMPMSymbol;
- (NSString *)mt_stringFromDateWithShortWeekdayTitle;
- (NSString *)mt_stringFromDateWithFullWeekdayTitle;
- (NSString *)mt_stringFromDateWithFormat:(NSString *)format localized:(BOOL)localized // http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
- (NSString *)mt_stringFromDateWithISODateTime;
- (NSString *)mt_stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;

+ (NSArray *)mt_datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
- (NSArray *)mt_hoursInCurrentDayAsDatesCollection;
- (BOOL)mt_isInAM;
- (BOOL)mt_isStartOfAnHour;
- (NSUInteger)mt_weekdayStartOfCurrentMonth;
- (NSUInteger)mt_daysInCurrentMonth;
- (NSUInteger)mt_daysInPreviousMonth;
- (NSUInteger)mt_daysInNextMonth;
- (NSDate *)mt_inTimeZone:(NSTimeZone *)timezone;
```

### NSDateComponents Additions

```objective-c
NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 October 2009"];
[comps mt_stringValue]   // => @"10 October 2009"

NSDateComponents *comps = [NSDateComponents componentsFromString:@"October 2009"];
[comps mt_stringValue]   // => @"October 2009"

NSDateComponents *comps = [NSDateComponents componentsFromString:@"2009"];
[comps mt_stringValue]   // => @"2009"

NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 2009"];
[comps mt_stringValue]   // => @"October 2009"

NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 July"];
[comps mt_stringValue]   // => @"10 July"

NSDateComponents *comps = [NSDateComponents componentsFromString:@"10"];
[comps mt_stringValue]   // => @"October"
```

### Contributors

* [Adam Kirk](https://github.com/atomkirk) [@atomkirk](https://twitter.com/atomkirk)
* [Parker Wightman](https://github.com/pwightman) [@parkerwightman](https://twitter.com/parkerwightman)
* [James Schultz](https://github.com/boxenjim) [@boxenjim](https://twitter.com/boxenjim)
* [Good Samaritans](https://github.com/mysterioustrousers/MTDates/contributors)
