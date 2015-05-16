//
//  PFBatteryInfo.m
//  PFBatteryInfo
//
//  Created by Perceval FARAMAZ on 15/05/15.
//  Copyright (c) 2015 faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>
#import <IOKit/pwr_mgt/IOPM.h>
#import <IOKit/pwr_mgt/IOPMLib.h>
#import "PFSK_OSX+Battery.h"

@implementation PFSystemKit(Battery)
/*+(PFSystemKitError) batVoltage:(NSNumber**)ret __attribute__((nonnull (1)))
{
	NSDictionary *advancedBatteryInfo = [self getAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batVoltage = [advancedBatteryInfo objectForKey:@"Voltage"]; //units mV
	return _batVoltage;
}

+(PFSystemKitError) batCurrentAmperage:(NSNumber**)ret __attribute__((nonnull (1)))
{
	NSDictionary *advancedBatteryInfo = [self getAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batCurrentAmperage = [advancedBatteryInfo objectForKey:@"Current"]; //units mAh
	return _batCurrentAmperage;
}

- (NSNumber *) batMaxCapacity
{
	NSDictionary *advancedBatteryInfo = [self getAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batMaxCapacity = [advancedBatteryInfo objectForKey:@"Capacity"]; //units mAh
	return _batMaxCapacity;
}

- (NSNumber *) batDesignCapacity
{
	NSDictionary *advancedBatteryInfo = [self getAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batDesignCapacity = [advancedBatteryInfo objectForKey:@"DesignCapacity"]; //units mAh
	return _batDesignCapacity;
}
____________________________________________________––––––––––––––––––––––––––––––––––––––––––––
- (NSNumber *) batCycleCount
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batCycleCount = [moreAdvancedBatteryInfo objectForKey:@"CycleCount"];
	return _batCycleCount;
}

- (NSNumber *) batDesignCycleCount
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batDesignCycleCount = [moreAdvancedBatteryInfo objectForKey:@"DesignCycleCount9C"];
	return _batDesignCycleCount;
}

- (NSNumber *) batWatts
{
	NSDictionary *advancedBatteryInfo = [self getAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batWatts = [NSNumber numberWithDouble:[[advancedBatteryInfo objectForKey:@"Amperage"] doubleValue] / 1000 * [_batVoltage doubleValue] / 1000]; //units Wh
	return _batWatts;
}

- (NSNumber *) batTemperature
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batTemperature = [NSNumber numberWithDouble:[[moreAdvancedBatteryInfo objectForKey:@"Temperature"] doubleValue] / 100]; //unit Celsiuses
	return _batTemperature;
}

- (NSString *) batHSNumber
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batHSNumber = [moreAdvancedBatteryInfo objectForKey:@"BatterySerialNumber"];
	return _batHSNumber;
}

- (NSString *) batName
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batName = [moreAdvancedBatteryInfo objectForKey:@"DeviceName"];
	return _batName;
}

- (NSString *) batManufacturer
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	//NSNumber *Voltage =
	_batManufacturer = [moreAdvancedBatteryInfo objectForKey:@"Manufacturer"];
	return _batManufacturer;
}

- (NSDate *) batManufactureDate
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	unsigned int state = [[moreAdvancedBatteryInfo objectForKey:@"ManufactureDate"] intValue];
	
	NSDateComponents* manufactureDateComponents = [[NSDateComponents alloc]init];
	manufactureDateComponents.year = (state >> 9) + 1980;
	manufactureDateComponents.month = (state >> 5) & 0xF;
	manufactureDateComponents.day = state & 0x1F;
	_batManufactureDate = [[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents];
	return _batManufactureDate;
}

- (NSNumber *) batTimeRemaining
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	_batTimeRemaining = [moreAdvancedBatteryInfo objectForKey:@"AvgTimeToEmpty"];
	return _batTimeRemaining;
}


- (NSNumber *) batIsPresent
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	_batIsPresent = [moreAdvancedBatteryInfo objectForKey:@"BatteryInstalled"];
	return _batIsPresent;
}

- (NSNumber *) batIsFull
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	_batIsFull = [moreAdvancedBatteryInfo objectForKey:@"FullyCharged"];
	return _batIsFull;
}

- (NSNumber *) batIsCharging
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	_batIsCharging = [moreAdvancedBatteryInfo objectForKey:@"IsCharging"];
	return _batIsCharging;
}

- (NSNumber *) batIsACConnected
{
	NSDictionary *moreAdvancedBatteryInfo = [self getMoreAdvancedBatteryInfo];
	_batIsACConnected = [moreAdvancedBatteryInfo objectForKey:@"ExternalConnected"];
	return _batIsACConnected;
}
*/

-(NSDictionary *)getMoreAdvancedBatteryInfo
{
	CFMutableDictionaryRef matching, properties = NULL;
	io_registry_entry_t entry = 0;
	// same as matching = IOServiceMatching("IOPMPowerSource");
	matching = IOServiceNameMatching("AppleSmartBattery");
	entry = IOServiceGetMatchingService(kIOMasterPortDefault, matching);
	IORegistryEntryCreateCFProperties(entry, &properties, NULL, 0);
	return (__bridge NSDictionary *)properties;
	//IOObjectRelease(entry);
}

@end