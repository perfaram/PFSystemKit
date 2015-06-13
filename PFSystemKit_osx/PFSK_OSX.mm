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
/*#import "PFSK_OSX+CPU.h"
#import "PFSK_OSX+GPU.h"
#import "PFSK_OSX+RAM.h"
#import "PFSK_OSX+GPU.h"*/
#import "PFSK_Common+Machine.h"

@interface PFSK_Common()
//+(PFSystemKitError) sysctlStringForKey:(char*)key intoChar:(std::string&)answerChar;
//+(PFSystemKitError) sysctlFloatForKey:(char*)key intoFloat:(CGFloat&)answerFloat;
@end

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
		[sharedInstance updateExpertReport];
		[sharedInstance updateRomReport];
		[sharedInstance updateSmcReport];
		[sharedInstance updateBatteryReport];
	});
	return sharedInstance;
}

-(BOOL) updateExpertReport {
	if (!firstRunDoneForExpertDevice) {
		kern_return_t result;
		pexEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPlatformExpertDevice"));
		if (pexEntry == 0) {
			_error = PFSKReturnComponentUnavailable;
			return false;
		}
		CFMutableDictionaryRef pexProps = NULL;
		result = IORegistryEntryCreateCFProperties(pexEntry, &pexProps, NULL, 0);
		if (result!=kIOReturnSuccess) {
			_error = PFSKReturnIOKitCFFailure;
			_extError = result;
			return false;
		} else {
			platformExpertRawDict = (__bridge_transfer NSDictionary*)pexProps;
			[self setValue:[platformExpertRawDict objectForKey:@"model"] forKey:@"model"];
			[self setValue:[platformExpertRawDict objectForKey:@"board-id"] forKey:@"boardID"];
			[self setValue:[platformExpertRawDict objectForKey:@kIOPlatformSerialNumberKey] forKey:@"serial"];
			[self setValue:[platformExpertRawDict objectForKey:@kIOPlatformUUIDKey] forKey:@"hardwareUUID"];
		}
		firstRunDoneForExpertDevice = 1;
	}
	return true;
}

-(BOOL) updateRomReport {
	if (!firstRunDoneForROM) {
		kern_return_t result;
		romEntry = IORegistryEntryFromPath(masterPort, "IODeviceTree:/rom@0");
		if (romEntry == 0) {
			_error = PFSKReturnComponentUnavailable;
			return false;
		}
		CFMutableDictionaryRef romProps = NULL;
		result = IORegistryEntryCreateCFProperties(romEntry, &romProps, NULL, 0);
		if (result!=kIOReturnSuccess) {
			_error = PFSKReturnIOKitCFFailure;
			_extError = result;
			return false;
		} else {
			romRawDict = (__bridge_transfer NSDictionary*)romProps;
			val4Key("romVersion", [romRawDict objectForKey:@"version"]);
			NSString* dateStr = [NSString.alloc initWithData:[romRawDict objectForKey:@"release-date"] encoding:NSUTF8StringEncoding];
			NSDateComponents* romDateComps = [NSDateComponents.alloc init];
			NSArray* romDateStrSplitted = [dateStr componentsSeparatedByString:@"/"];
			[romDateComps setMonth:[[romDateStrSplitted objectAtIndex:0] integerValue]];
			[romDateComps setDay:[[romDateStrSplitted objectAtIndex:1] integerValue]];
			[romDateComps setYear:(2000+[[romDateStrSplitted objectAtIndex:2] integerValue])];
			val4Key("romReleaseDate", [[NSCalendar currentCalendar] dateFromComponents:romDateComps]);
		}
		firstRunDoneForROM = 1;
	}
	return true;
}

-(BOOL) updateSmcReport {
	kern_return_t result;
	if (!firstRunDoneForSMC) {
		smcEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("AppleSMC"));
		if (smcEntry == 0) {
			_error = PFSKReturnComponentUnavailable;
			return false;
		}
	}
	CFMutableDictionaryRef smcProps = NULL;
	result = IORegistryEntryCreateCFProperties(smcEntry, &smcProps, NULL, 0);
	if (result!=kIOReturnSuccess) {
		_error = PFSKReturnIOKitCFFailure;
		_extError = result;
		return false;
	} else {
		smcRawDict = (__bridge_transfer NSDictionary*)smcProps;
		if (!firstRunDoneForSMC) { //reboot needed for SMC update, or for the ShutdownCause to change
			val4Key("smcVersion", [smcRawDict objectForKey:@"smc-version"]);
			val4Key("shutdownCause", [smcRawDict objectForKey:@"ShutdownCause"]);
			firstRunDoneForSMC = 1;
		}
		val4Key("sleepCause", [smcRawDict objectForKey:@"SleepCause"]);
	}
	return true;
}

-(BOOL) updateCPUReport {
	PFSystemKitError locResult;
	BOOL errorOccured;
	NSString* cpuVendor;
	NSString* cpuBrand;
	
	NSNumber* cpuThreads, cpuCores, cpuS, cpuFreq, cpuL2, cpul3;
	
	PFSystemKitCPUArches arch;
	
	locResult = _cpuVendor(&cpuVendor);
	if (locResult != PFSKReturnSuccess) {
		cpuVendor = @"-";
		errorOccured = 1;
	}
	
	locResult = _cpuBrand(&cpuBrand);
	if (locResult != PFSKReturnSuccess) {
		cpuBrand = @"-";
		errorOccured = 1;
	}
	
	locResult = _cpuArchitecture(&arch);
	if (locResult != PFSKReturnSuccess) {
		arch = PFSKCPUArchesUnknown;
		errorOccured = 1;
	}
	
	locResult = _cpuThreadCount(&cpuThreads);
	if (locResult != PFSKReturnSuccess) {
		cpuThreads = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuCoreCount(&cpuCores);
	if (locResult != PFSKReturnSuccess) {
		cpuCores = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuCount(&cpuS);
	if (locResult != PFSKReturnSuccess) {
		cpuS = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuFrequency(&cpuFreq);
	if (locResult != PFSKReturnSuccess) {
		cpuFreq = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuL2Cache(&cpuL2);
	if (locResult != PFSKReturnSuccess) {
		cpuL2 = @(-1);
		errorOccured = 1;
	}
	
	locResult = _cpuL3Cache(&cpuL3);
	if (locResult != PFSKReturnSuccess) {
		cpuL3 = @(-1);
		errorOccured = 1;
	}
	
	cpuReport = [PFSystemCPUReport.alloc initWithCount:cpuS
												 brand:cpuBrand
											 coreCount:cpuCores
										   threadCount:cpuThreads
											 frequency:cpuFreq
													l2:cpuL2
													l3:cpuL3
										  architecture:arch
												vendor:cpuVendor];
	
	error = synthesizeError(locResult);
	if (result != PFSKReturnSuccess) {
		return false;
	}
	return true;
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
			batteryReport = [PFSystemBatteryReport.alloc initWithDCC:[batteryRawDict objectForKey:@"DesignCycleCount9C"]
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

#pragma mark - Class methods (actual core code)

#pragma mark - Getters
@synthesize family;
@synthesize familyString;
@synthesize version;
@synthesize versionString;
@synthesize endianness;
@synthesize endiannessString;
@synthesize model;
@synthesize serial;
@dynamic 	memorySize;
@synthesize cpuReport;
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
