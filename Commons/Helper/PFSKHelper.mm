//
//  PFSKHelper.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 18/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import "PFSKHelper.h"
#import <string>

@implementation PFSKHelper
+(CFTypeRef) rawValue:(char*)value toCFTypeRef:(CFTypeID)typeID {
	CFTypeRef     valueRef = 0;
	long          cnt, cnt2, length;
	unsigned long number, tmp;
	
	if (typeID == CFBooleanGetTypeID()) {
		if (!strcmp("true", value)) valueRef = kCFBooleanTrue;
		else if (!strcmp("false", value)) valueRef = kCFBooleanFalse;
	} else if (typeID == CFNumberGetTypeID()) {
		number = strtol(value, 0, 0);
		valueRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type,
								  &number);
	} else if (typeID == CFStringGetTypeID()) {
		valueRef = CFStringCreateWithCString(kCFAllocatorDefault, value,
											 kCFStringEncodingUTF8);
	} else if (typeID == CFDataGetTypeID()) {
		length = strlen(value);
		for (cnt = cnt2 = 0; cnt < length; cnt++, cnt2++) {
			if (value[cnt] == '%') {
				if (!ishexnumber(value[cnt + 1]) ||
	    !ishexnumber(value[cnt + 2])) return 0;
				number = toupper(value[++cnt]) - '0';
				if (number > 9) number -= 7;
				tmp = toupper(value[++cnt]) - '0';
				if (tmp > 9) tmp -= 7;
				number = (number << 4) + tmp;
				value[cnt2] = number;
			} else value[cnt2] = value[cnt];
		}
		valueRef = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, (const UInt8 *)value,
											   cnt2, kCFAllocatorDefault);
	} else return 0;
	
	return valueRef;
}

+(NSDictionary*)deltaFromDictionary:(NSDictionary*)a andDictionary:(NSDictionary*)b {
	NSArray *allkeys1=[a allKeys];
	NSArray *allkeys2=[b allKeys];
	
	NSMutableSet *setOne = [NSMutableSet setWithArray:allkeys1];
	NSMutableSet *setTwo = [NSMutableSet setWithArray:allkeys2];
	
	[setTwo unionSet:setOne];
	[setTwo minusSet:setOne];
	
	NSArray *arrayOneResult = [setTwo allObjects];
	NSMutableDictionary* result = [NSMutableDictionary.alloc init];
	[arrayOneResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result setObject:[b objectForKey:obj] forKey:obj];
	}];
	return [NSDictionary dictionaryWithDictionary:result];
}

+(NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat {
	NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
	[dtFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	[dtFormatter setDateStyle:NSDateFormatterShortStyle];
	[dtFormatter setDateFormat:inFormat];
	[dtFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	NSDate* dateOutput = [dtFormatter dateFromString:inStrDate];
	return dateOutput;
}

@end
