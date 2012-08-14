MTDates
=======

MTDates is an category on NSDate that makes common date calculations super easy.

### Installation

In your Podfile, add this line:

    pod "MTDates"
  
### Example Usage

	NSDate *date = [formatter dateFromString:@"07/11/1986 11:29am"];
	
	[date year]; 								   					// => 1986
	                                               					
	[date weekDayOfWeek]; 						   					// => 6
	                                               					
	[date minuteOfHour];						   					// => 29
	                                               					
	[[date startOfPreviousYear] year];			   					// => 1985
	
	[[date startOfPreviousYear] stringFromDateWithISODateTime];		// => @"1985-01-01T00:00:00Z"
	
	[[date startOfPreviousMonth] stringFromDatesFullMonth];			// => @"June"

