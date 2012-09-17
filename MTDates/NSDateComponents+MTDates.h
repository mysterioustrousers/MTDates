//
//  NSDateComponents+NSDateComponents_MTDates.h
//  MTDates
//
//  Created by Adam Kirk on 9/17/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 For help working with the date property on events. The String
 format is: dd MMMM yyyy (e.g. 10 October 1999)

*/

@interface NSDateComponents (MTDates)

+ (NSDateComponents *)componentsFromString:(NSString *)string;
- (NSString *)stringValue;
- (BOOL)isEqualToDateComponents:(NSDateComponents *)components;

@end
