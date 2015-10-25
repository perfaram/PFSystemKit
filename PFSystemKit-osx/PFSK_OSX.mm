//
//  PFSK_OSX.m
//  PFSystemKit
//
//  Created by Perceval FARAMAZ on 19/04/15.
//  Copyright (c) 2015 Perceval FARAMAZ. All rights reserved.
//

#import <sys/sysctl.h>
#import <CoreFoundation/CoreFoundation.h>
#import <string>
#import <vector>
#import "PFSKHelper.h"
#import "PFSK_OSX.h"
#import "PFSystemKitPlatformReport.h"
#import "PFSystemKitBatteryReport.h"
#import "PFSystemKitCPUReport.h"

@implementation PFSystemKit
#pragma mark - Singleton pattern
/**
 * PFSystemKit singleton instance retrieval method
 */
+(instancetype) investigate {
	static PFSystemKit* sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		[sharedInstance updateBatteryReport];
	});
	return sharedInstance;
}

-(BOOL) ramReport:(NSError Ind2_NUAR)err {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitRAMReport*) ramReport {
    if (ramReport == nil) {
        ramReport = [PFSystemKitRAMReport.alloc initWithError:nil];
        return ramReport;
    } else
        return ramReport;
}

-(BOOL) cpuReport:(NSError Ind2_NUAR)err {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitCPUReport*) cpuReport {
    if (cpuReport == nil) {
        cpuReport = [PFSystemKitCPUReport.alloc initWithError:nil];
        return cpuReport;
    } else
        return cpuReport;
}

-(BOOL) platformReport:(NSError Ind2_NUAR)err {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithError:err];
        if (err)
            return false;
        else
            return true;
    } else
        return true;
}

-(PFSystemKitPlatformReport*) platformReport {
    if (platformReport == nil) {
        platformReport = [PFSystemKitPlatformReport.alloc initWithError:nil];
        return platformReport;
    } else
        return platformReport;
}

-(BOOL) updateBatteryReport {
	kern_return_t result;
	if (!firstRunDoneForBattery) {
		batEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPMPowerSource"));
		if (batEntry == 0) {
			_error = PFSKReturnComponentUnavailable;
			return false;
		}
	}
	CFMutableDictionaryRef batProps = NULL;
	result = IORegistryEntryCreateCFProperties(batEntry, &batProps, NULL, 0);
	if (result!=kIOReturnSuccess) {
		_error = PFSKReturnIOKitCFFailure;
		_extError = result;
		return false;
	} else {
		batteryRawDict = (__bridge_transfer NSDictionary*)batProps;
		NSMutableDictionary* temp = [NSMutableDictionary.alloc init];
		
		if (!firstRunDoneForBattery) { //static keys
			//[temp setObject:[batteryRawDict objectForKey:@"DesignCapacity"] forKey:@"DesignedCapacity"];
			unsigned int manufactureDateAsInt = [[batteryRawDict objectForKey:@"ManufactureDate"] intValue];
			NSDateComponents* manufactureDateComponents = [[NSDateComponents alloc]init];
			manufactureDateComponents.year = (manufactureDateAsInt >> 9) + 1980;
			manufactureDateComponents.month = (manufactureDateAsInt >> 5) & 0xF;
			manufactureDateComponents.day = manufactureDateAsInt & 0x1F;
			[temp setObject:[[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents] forKey:@"manufactureDate"];
			batteryReport = [PFSystemKitBatteryReport.alloc initWithDCC:[batteryRawDict objectForKey:@"DesignCycleCount9C"]
						 serial:[batteryRawDict objectForKey:@"BatterySerialNumber"]
						  model:[batteryRawDict objectForKey:@"DeviceName"]
				   manufacturer:[batteryRawDict objectForKey:@"Manufacturer"]
				manufactureDate:[[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents]];
			firstRunDoneForBattery = 1;
		}
		
		NSDateComponents* differenceDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
																		   fromDate:[temp objectForKey:@"manufactureDate"]
																			 toDate:[NSDate date]
																			options:0];
		[batteryReport updateWithIsPresent:[[batteryRawDict objectForKey:@"BatteryInstalled"] intValue]
									isFull:[[batteryRawDict objectForKey:@"FullyCharged"] intValue]
								isCharging:[[batteryRawDict objectForKey:@"IsCharging"] intValue]
							 isACConnected:[[batteryRawDict objectForKey:@"ExternalConnected"] intValue]
								  amperage:[batteryRawDict objectForKey:@"Amperage"]
						   currentCapacity:[batteryRawDict objectForKey:@"CurrentCapacity"]
							   maxCapacity:[batteryRawDict objectForKey:@"MaxCapacity"]
								   voltage:[batteryRawDict objectForKey:@"Voltage"]
								cycleCount:[batteryRawDict objectForKey:@"CycleCount"]
									health:@(([[batteryRawDict objectForKey:@"MaxCapacity"] intValue] / [[batteryRawDict objectForKey:@"DesignCapacity"] intValue])*100)
							   temperature:@([[batteryRawDict objectForKey:@"Temperature"] doubleValue] / 100)
									 power:@([[batteryRawDict objectForKey:@"Amperage"] doubleValue] / 1000 * [[batteryRawDict objectForKey:@"Voltage"] doubleValue] / 1000)
									   age:@([differenceDate day])];
		return true;
	}
}

#pragma mark - Getters
@synthesize batteryReport;


#pragma mark - NSObject std methods
-(void) finalize { //cleanup everything
	IOObjectRelease(nvrEntry);
	IOObjectRelease(pexEntry);
	IOObjectRelease(smcEntry);
	IOObjectRelease(romEntry);
	[super finalize];
	return;
}

-(instancetype) init {
	if (!(self = [super init])) {
		return nil;
	}
	_writeLockState = PFSKLockStateLocked;
	_error = PFSKReturnUnknown;
	_extError = 0;
	kern_return_t IOresult;
	IOresult = IOMasterPort(bootstrap_port, &masterPort);
	if (IOresult!=kIOReturnSuccess) {
		_error = PFSKReturnNoMasterPort;
		_extError = IOresult;
		return nil;
	}
	return self;
}
@end
