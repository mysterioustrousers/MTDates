MTDates
=======

MTDates is an category on NSDate that makes common date calculations super easy.

### Installation

In your Podfile, add this line:

    pod "MTDates"
  
pod? => https://github.com/CocoaPods/CocoaPods/
NOTE: You may need to add `-all_load` to "Other Linker Flags" in your targets build settings if the pods library only contains categories.
	
### Example Usage

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MM/dd/yyyy hh:mma";
	NSDate *date = [formatter dateFromString:@"07/11/1986 11:29am"];
	
	[date year]; 								   					// => 1986
	                                               					
	[date weekDayOfWeek]; 						   					// => 6
	                                               					
	[date minuteOfHour];						   					// => 29
	                                               					
	[[date startOfPreviousYear] year];			   					// => 1985
	
	[[date startOfPreviousYear] stringFromDateWithISODateTime];		// => @"1985-01-01T00:00:00Z"
	
	[[date startOfPreviousMonth] stringFromDatesFullMonth];			// => @"June"
	

### Creating Dates

	[NSDate dateFromYear:1986 week:28 weekDay:6 hour:11 minute:29 second:0];

### Dates From Other Dates

	[date dateByAddingYears:0 months:0 weeks:2 days:0 hours:1 minutes:24 seconds:0];
	
	[date dateYearsAfter:8];
	
	[date oneYearNext];
	
	[date dateMonthsBefore:4];
	

### Comparing Dates

	[date isAfter:date2];
	
	[date2 isBefore:date];
	
	[date3 isOnOrBefore:date];
	
	[date2 isWithinSameWeek:date];
	
	[date4 isWithinSameDay:date];

### Other Coolness

	[date weekdayStartOfCurrentMonth];
	
	[date daysInCurrentMonth];
	[date daysInPreviousMonth]
	[date daysInNextMonth]

### International

	[NSDate setFirstDayOfWeek:1];
	[NSDate setFirstDayOfWeek:4];
	
	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemISO];
	[NSDate setWeekNumberingSystem:MTDateWeekNumberingSystemUS];

### All methods

	+ (void)setLocale:(NSLocale *)locale;
	+ (void)setTimeZone:(NSTimeZone *)timeZone;
	+ (void)setFirstDayOfWeek:(NSUInteger)firstDay; // Sunday: 1, Saturday: 7
	+ (void)setWeekNumberingSystem:(MTDateWeekNumberingSystem)system;

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

	+ (NSArray *)shortWeekdaySymbols;
	+ (NSArray *)weekdaySymbols;
	+ (NSArray *)veryShortWeekdaySymbols;
	+ (NSArray *)shortMonthlySymbols;
	+ (NSArray *)monthlySymbols;
	+ (NSArray *)veryShortMonthlySymbols;

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

	- (BOOL)isAfter:(NSDate *)date;
	- (BOOL)isBefore:(NSDate *)date;
	- (BOOL)isOnOrAfter:(NSDate *)date;
	- (BOOL)isOnOrBefore:(NSDate *)date;
	- (BOOL)isWithinSameMonth:(NSDate *)date;
	- (BOOL)isWithinSameWeek:(NSDate *)date;
	- (BOOL)isWithinSameDay:(NSDate *)date;
	- (BOOL)isWithinSameHour:(NSDate *)date;
	- (BOOL)isBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;

	- (NSString *)stringFromDateWithHourAndMinuteFormat:(MTDateHourFormat)format;
	- (NSString *)stringFromDateWithShortMonth;
	- (NSString *)stringFromDateWithFullMonth;
	- (NSString *)stringFromDateWithAMPMSymbol;
	- (NSString *)stringFromDateWithShortWeekdayTitle;
	- (NSString *)stringFromDateWithFullWeekdayTitle;
	- (NSString *)stringFromDateWithFormat:(NSString *)format;		// http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
	- (NSString *)stringFromDateWithISODateTime;
	- (NSString *)stringFromDateWithGreatestComponentsForSecondsPassed:(NSTimeInterval)interval;

	+ (NSArray *)datesCollectionFromDate:(NSDate *)startDate untilDate:(NSDate *)endDate;
	- (NSArray *)hoursInCurrentDayAsDatesCollection;
	- (BOOL)isInAM;
	- (BOOL)isStartOfAnHour;
	- (NSUInteger)weekdayStartOfCurrentMonth;
	- (NSUInteger)daysInCurrentMonth;
	- (NSUInteger)daysInPreviousMonth;
	- (NSUInteger)daysInNextMonth;
	- (NSDate *)inTimeZone:(NSTimeZone *)timezone;

### NSDateComponents Additions

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 October 2009"];
	[comps stringValue] 	// => @"10 October 2009"

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"October 2009"];
	[comps stringValue] 	// => @"October 2009"

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"2009"];
	[comps stringValue] 	// => @"2009"

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 2009"];
	[comps stringValue] 	// => @"October 2009"

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"10 July"];
	[comps stringValue] 	// => @"10 July"

	NSDateComponents *comps = [NSDateComponents componentsFromString:@"10"];
	[comps stringValue] 	// => @"October"

### Contributors

* [Adam Kirk](https://github.com/atomkirk) @atomkirk
* [Parker Wightman](https://github.com/pwightman) @parkerwightman
* [James Schultz](https://github.com/boxenjim) @boxenjim
* [Ryan Maxwell](https://github.com/ryanmaxwell) @ryanmaxwell